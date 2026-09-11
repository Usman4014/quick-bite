// ignore_for_file: file_names

import 'dart:async';

import 'package:get/get.dart';
import 'package:quick_bite/models/Banner_Model.dart';
import 'package:quick_bite/services/Banner_Service.dart';

class BannerController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final BannerService _bannerService = BannerService();

  //============================================================
  // BANNERS
  //============================================================

  final RxList<BannerModel> banners = <BannerModel>[].obs;

  //============================================================
  // STATE
  //============================================================

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  //============================================================
  // STREAM SUBSCRIPTION
  //============================================================

  StreamSubscription<List<BannerModel>>? _bannerSubscription;

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    loadInitialBanners();
  }

  //============================================================
  // LOAD BANNERS
  //============================================================

  void loadInitialBanners() {
    //==========================================================
    // ALREADY LISTENING
    //==========================================================

    if (_bannerSubscription != null) {
      return;
    }

    //==========================================================
    // START LISTENING
    //==========================================================

    isLoading.value = true;
    errorMessage.value = '';

    _bannerSubscription = _bannerService.getBannersStream().listen(
      (List<BannerModel> data) {
        //======================================================
        // UPDATE BANNERS
        //======================================================

        banners.assignAll(data);

        //======================================================
        // LOADING COMPLETE
        //======================================================

        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (Object error) {
        //======================================================
        // ERROR
        //======================================================

        isLoading.value = false;
        errorMessage.value = error.toString();
      },
    );
  }

  //============================================================
  // REFRESH BANNERS
  //============================================================

  Future<void> refreshBanners() async {
    await _bannerSubscription?.cancel();

    _bannerSubscription = null;

    loadInitialBanners();
  }

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _bannerSubscription?.cancel();

    _bannerSubscription = null;

    super.onClose();
  }
}
