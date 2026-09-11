// ignore_for_file: file_names

import 'dart:async';

import 'package:get/get.dart';

import 'package:quick_bite/models/App_Settings_Model.dart';
import 'package:quick_bite/services/App_Settings_Service.dart';

class AppSettingsController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final AppSettingsService _service = AppSettingsService();

  //============================================================
  // SETTINGS
  //============================================================

  final Rx<AppSettingsModel> settings =
      AppSettingsModel.defaults().obs;

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = true.obs;

  //============================================================
  // ERROR
  //============================================================

  final RxString errorMessage = ''.obs;

  //============================================================
  // STREAM SUBSCRIPTION
  //============================================================

  StreamSubscription<AppSettingsModel>? _settingsSubscription;

  //============================================================
  // INITIAL LOAD COMPLETER
  //============================================================

  Completer<void>? _initialLoadCompleter;

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    listenToSettings();
  }

  //============================================================
  // LISTEN TO SETTINGS
  //============================================================

  Future<void> listenToSettings() async {
    // Prevent duplicate listeners.
    if (_settingsSubscription != null) {
      if (isLoading.value &&
          _initialLoadCompleter != null) {
        await _initialLoadCompleter!.future;
      }

      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    _initialLoadCompleter = Completer<void>();

    //==========================================================
    // ONE REAL-TIME FIRESTORE LISTENER
    //==========================================================

    _settingsSubscription =
        _service.settingsStream().listen(
      (AppSettingsModel newSettings) {
        settings.value = newSettings;

        //======================================================
        // FIRST SNAPSHOT
        //======================================================

        if (isLoading.value) {
          isLoading.value = false;

          if (_initialLoadCompleter != null &&
              !_initialLoadCompleter!.isCompleted) {
            _initialLoadCompleter!.complete();
          }
        }

        errorMessage.value = '';
      },
      onError: (Object error) {
        isLoading.value = false;

        errorMessage.value =
            'Unable to load app settings.';

        if (_initialLoadCompleter != null &&
            !_initialLoadCompleter!.isCompleted) {
          _initialLoadCompleter!.complete();
        }
      },
    );

    //==========================================================
    // WAIT FOR FIRST RESULT
    //==========================================================

    await _initialLoadCompleter!.future;
  }

  //============================================================
  // REFRESH SETTINGS
  //============================================================

  Future<void> refreshSettings() async {
    //==========================================================
    // NO EXTRA FIRESTORE GET()
    //==========================================================

    await _settingsSubscription?.cancel();

    _settingsSubscription = null;
    _initialLoadCompleter = null;

    await listenToSettings();
  }

  //============================================================
  // CONVENIENCE GETTERS
  //============================================================

  String get restaurantName =>
      settings.value.restaurantName;

  String get restaurantPhone =>
      settings.value.restaurantPhone;

  String get restaurantEmail =>
      settings.value.restaurantEmail;

  String get restaurantAddress =>
      settings.value.restaurantAddress;

  double get deliveryRadius =>
      settings.value.deliveryRadius;

  double get deliveryFee =>
      settings.value.deliveryFee;

  double get minimumOrderAmount =>
      settings.value.minimumOrderAmount;

  int get estimatedDeliveryMinutes =>
      settings.value.estimatedDeliveryMinutes;

  bool get acceptOrders =>
      settings.value.acceptOrders;

  bool get allowCancellation =>
      settings.value.allowCancellation;

  int get preparationTimeMinutes =>
      settings.value.preparationTimeMinutes;

  bool get cashOnDelivery =>
      settings.value.cashOnDelivery;

  bool get onlinePayment =>
      settings.value.onlinePayment;

  bool get newOrderNotifications =>
      settings.value.newOrderNotifications;

  bool get orderStatusNotifications =>
      settings.value.orderStatusNotifications;

  bool get maintenanceMode =>
      settings.value.maintenanceMode;

  bool get appAvailable =>
      settings.value.appAvailable;

  //============================================================
  // ORDER AVAILABILITY
  //============================================================

  bool get canPlaceOrders {
    return appAvailable &&
        !maintenanceMode &&
        acceptOrders;
  }

  //============================================================
  // PAYMENT AVAILABILITY
  //============================================================

  bool get hasAvailablePaymentMethod {
    return cashOnDelivery ||
        onlinePayment;
  }

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _settingsSubscription?.cancel();

    _settingsSubscription = null;
    _initialLoadCompleter = null;

    super.onClose();
  }
}