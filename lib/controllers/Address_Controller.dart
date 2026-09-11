// ignore_for_file: file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:quick_bite/models/AddressNeighborhood_Model.dart';
import 'package:quick_bite/models/AddressTypeVariant_Model.dart';
import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/services/Address_Service.dart';

class AddressController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final AddressService _addressService = AddressService();

  //============================================================
  // FIREBASE AUTH
  //============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //============================================================
  // ADDRESSES
  //============================================================

  final RxList<AddressModel> addresses = <AddressModel>[].obs;

  //============================================================
  // ADDRESS TYPES
  //============================================================

  final RxList<AddressTypeVariantModel> addressTypes =
      <AddressTypeVariantModel>[].obs;

  //============================================================
  // NEIGHBORHOODS
  //============================================================

  final RxList<AddressNeighborhoodModel> neighborhoods =
      <AddressNeighborhoodModel>[].obs;

  //============================================================
  // STATE
  //============================================================

  // IMPORTANT:
  // Starts as TRUE.
  //
  // The AddressScreen will show AddressShimmer until
  // the first Firestore address snapshot is received.
  final RxBool isLoading = true.obs;

  final RxString errorMessage = ''.obs;

  //============================================================
  // SUBSCRIPTIONS
  //============================================================

  StreamSubscription<List<AddressModel>>? _addressSubscription;

  StreamSubscription<List<AddressTypeVariantModel>>? _addressTypesSubscription;

  StreamSubscription<List<AddressNeighborhoodModel>>?
  _neighborhoodsSubscription;

  StreamSubscription<User?>? _authSubscription;

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    // Start address types and neighborhoods.
    _startMetadataListeners();

    // Start authentication listener.
    _startAuthListener();
  }

  //============================================================
  // AUTH LISTENER
  //============================================================

  void _startAuthListener() {
    _authSubscription?.cancel();

    _authSubscription = _auth.authStateChanges().listen((user) {
      //========================================================
      // USER LOGGED OUT
      //========================================================

      if (user == null) {
        _addressSubscription?.cancel();
        _addressSubscription = null;

        addresses.clear();

        errorMessage.value = '';

        // There is no Firestore address query to wait for.
        isLoading.value = false;

        return;
      }

      //========================================================
      // USER LOGGED IN
      //========================================================

      _startListener();
    });

    //==========================================================
    // HANDLE ALREADY AUTHENTICATED USER
    //==========================================================

    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      _startListener();
    }
    // IMPORTANT:
    // If currentUser is null, DO NOT set isLoading to false.
    //
    // Firebase may still be restoring the authentication state.
    // The shimmer must remain visible until auth is resolved.
  }

  //============================================================
  // CURRENT USER ID
  //============================================================

  String? get _userId {
    return _auth.currentUser?.uid;
  }

  //============================================================
  // START METADATA LISTENERS
  //============================================================

  void _startMetadataListeners() {
    _addressTypesSubscription?.cancel();
    _neighborhoodsSubscription?.cancel();

    //==========================================================
    // ADDRESS TYPES
    //==========================================================

    _addressTypesSubscription = _addressService.listenToAddressTypes().listen(
      (data) {
        addressTypes.assignAll(data);
      },
      onError: (_) {
        addressTypes.clear();
      },
    );

    //==========================================================
    // NEIGHBORHOODS
    //==========================================================

    _neighborhoodsSubscription = _addressService.listenToNeighborhoods().listen(
      (data) {
        neighborhoods.assignAll(data);
      },
      onError: (_) {
        neighborhoods.clear();
      },
    );
  }

  //============================================================
  // START FIRESTORE ADDRESS LISTENER
  //============================================================

  void _startListener() {
    final userId = _userId;

    //==========================================================
    // CANCEL PREVIOUS LISTENER
    //==========================================================

    _addressSubscription?.cancel();
    _addressSubscription = null;

    //==========================================================
    // USER NOT READY
    //==========================================================

    if (userId == null || userId.trim().isEmpty) {
      // IMPORTANT:
      // Keep loading TRUE.
      //
      // We haven't loaded the user's addresses yet.
      // Do NOT show EmptyAddress().
      isLoading.value = true;

      addresses.clear();
      errorMessage.value = '';

      return;
    }

    //==========================================================
    // START FIRESTORE LOADING
    //==========================================================

    isLoading.value = true;
    errorMessage.value = '';

    //==========================================================
    // FIRESTORE LISTENER
    //==========================================================

    _addressSubscription = _addressService
        .listenToAddresses(userId)
        .listen(
          (data) {
            //======================================================
            // FIRESTORE FIRST SNAPSHOT RECEIVED
            //======================================================

            addresses.assignAll(data);

            errorMessage.value = '';

            //======================================================
            // NOW STOP SHIMMER
            //
            // This happens only after Firestore has actually
            // returned the address data.
            //======================================================

            isLoading.value = false;
          },
          onError: (error) {
            //======================================================
            // FIRESTORE ERROR
            //======================================================

            addresses.clear();

            errorMessage.value = 'Unable to load addresses.';

            isLoading.value = false;
          },
        );
  }

  //============================================================
  // REFRESH LISTENER
  //============================================================

  void refreshAddresses() {
    _startListener();
  }

  //============================================================
  // ADD ADDRESS
  //============================================================

  Future<bool> addAddress(AddressModel address) async {
    final userId = _userId;

    if (userId == null || userId.trim().isEmpty) {
      errorMessage.value = 'User is not logged in.';

      return false;
    }

    try {
      await _addressService.addAddress(userId: userId, address: address);

      return true;
    } catch (error) {
      errorMessage.value = 'Unable to save address.';

      return false;
    }
  }

  //============================================================
  // UPDATE ADDRESS
  //============================================================

  Future<bool> updateAddress(AddressModel address) async {
    final userId = _userId;

    if (userId == null || userId.trim().isEmpty) {
      errorMessage.value = 'User is not logged in.';

      return false;
    }

    try {
      await _addressService.updateAddress(userId: userId, address: address);

      return true;
    } catch (error) {
      errorMessage.value = 'Unable to update address.';

      return false;
    }
  }

  //============================================================
  // REMOVE ADDRESS
  //============================================================

  Future<bool> removeAddress(AddressModel address) async {
    final userId = _userId;

    if (userId == null || userId.trim().isEmpty) {
      return false;
    }

    try {
      await _addressService.deleteAddress(
        userId: userId,
        addressId: address.id,
      );

      return true;
    } catch (error) {
      errorMessage.value = 'Unable to delete address.';

      return false;
    }
  }

  //============================================================
  // SELECT ADDRESS
  //============================================================

  Future<bool> selectAddress(AddressModel address) async {
    final userId = _userId;

    if (userId == null || userId.trim().isEmpty) {
      return false;
    }

    try {
      await _addressService.selectAddress(
        userId: userId,
        addressId: address.id,
      );

      return true;
    } catch (error) {
      errorMessage.value = 'Unable to select address.';

      return false;
    }
  }

  //============================================================
  // SET DEFAULT
  //============================================================

  Future<bool> setDefaultAddress(AddressModel address) async {
    final userId = _userId;

    if (userId == null || userId.trim().isEmpty) {
      return false;
    }

    try {
      await _addressService.setDefaultAddress(
        userId: userId,
        addressId: address.id,
      );

      return true;
    } catch (error) {
      errorMessage.value = 'Unable to set default address.';

      return false;
    }
  }

  //============================================================
  // SELECTED ADDRESS
  //============================================================

  AddressModel? get selectedAddress {
    for (final address in addresses) {
      if (address.isSelected) {
        return address;
      }
    }

    return null;
  }

  //============================================================
  // DEFAULT ADDRESS
  //============================================================

  AddressModel? get defaultAddress {
    for (final address in addresses) {
      if (address.isDefault) {
        return address;
      }
    }

    return null;
  }

  //============================================================
  // FIND ADDRESS
  //============================================================

  AddressModel? getAddressById(String id) {
    for (final address in addresses) {
      if (address.id == id) {
        return address;
      }
    }

    return null;
  }

  //============================================================
  // TOTAL
  //============================================================

  int get totalAddresses => addresses.length;

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _addressSubscription?.cancel();
    _addressTypesSubscription?.cancel();
    _neighborhoodsSubscription?.cancel();
    _authSubscription?.cancel();

    super.onClose();
  }
}
