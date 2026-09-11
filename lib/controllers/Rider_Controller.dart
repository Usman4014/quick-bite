// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:get/get.dart';
import 'package:quick_bite/models/Rider_Model.dart';
import 'package:quick_bite/services/Rider_Service.dart';

class RiderController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final RiderService _riderService = RiderService();

  //============================================================
  // RIDERS
  //============================================================

  final RxList<RiderModel> riders = <RiderModel>[].obs;

  //============================================================
  // STATE
  //============================================================

  final RxBool isLoading = true.obs;

  final RxString errorMessage = ''.obs;

  //============================================================
  // STREAM SUBSCRIPTION
  //============================================================

  StreamSubscription<List<RiderModel>>? _ridersSubscription;

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    listenToRiders();
  }

  //============================================================
  // LISTEN TO FIRESTORE
  //============================================================

  void listenToRiders() {
    // Prevent duplicate listeners.
    if (_ridersSubscription != null) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    _ridersSubscription = _riderService.listenToRiders().listen(
      (List<RiderModel> riderList) {
        riders.assignAll(riderList);

        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (Object error) {
        isLoading.value = false;
        errorMessage.value = 'Unable to load riders.';

        print('RIDER STREAM ERROR: $error');
      },
    );
  }

  //============================================================
  // REFRESH RIDERS
  //============================================================

  void refreshRiders() {
    _ridersSubscription?.cancel();
    _ridersSubscription = null;

    listenToRiders();
  }

  //============================================================
  // AVAILABLE RIDERS
  //============================================================

  List<RiderModel> get availableRiders {
    return riders
        .where((rider) => rider.isAvailable)
        .toList(growable: false);
  }

  //============================================================
  // FIND RIDER BY ID
  //============================================================

  RiderModel? getRiderById(String riderId) {
    for (final rider in riders) {
      if (rider.id == riderId) {
        return rider;
      }
    }

    return null;
  }

  //============================================================
  // ASSIGN RIDER
  //============================================================

  Future<RiderModel?> assignRider() async {
    RiderModel? selectedRider;

    // Find the first available rider without
    // creating an additional list.
    for (final rider in riders) {
      if (rider.isAvailable) {
        selectedRider = rider;
        break;
      }
    }

    if (selectedRider == null) {
      return null;
    }

    try {
      // Persist availability in Firestore.
      await _riderService.updateAvailability(
        riderId: selectedRider.id,
        isAvailable: false,
      );

      // Update local state immediately.
      selectedRider.isAvailable = false;
      riders.refresh();

      return selectedRider;
    } catch (error) {
      print('FAILED TO ASSIGN RIDER: $error');

      return null;
    }
  }

  //============================================================
  // RELEASE RIDER
  //============================================================

  Future<void> releaseRider(String riderId) async {
    final rider = getRiderById(riderId);

    if (rider == null) {
      return;
    }

    try {
      await _riderService.updateAvailability(
        riderId: riderId,
        isAvailable: true,
      );

      rider.isAvailable = true;
      riders.refresh();
    } catch (error) {
      print('FAILED TO RELEASE RIDER: $error');
    }
  }

  //============================================================
  // HAS AVAILABLE RIDER
  //============================================================

  bool get hasAvailableRider {
    for (final rider in riders) {
      if (rider.isAvailable) {
        return true;
      }
    }

    return false;
  }

  //============================================================
  // TOTAL RIDERS
  //============================================================

  int get totalRiders => riders.length;

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _ridersSubscription?.cancel();
    _ridersSubscription = null;

    super.onClose();
  }
}