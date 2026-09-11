// ignore_for_file: avoid_print, file_names

import 'package:get/get.dart';

import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/services/Special_Deal_Service.dart';

class SpecialDealsController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final SpecialDealService _specialDealService =
      SpecialDealService();

  //============================================================
  // SPECIAL DEALS
  //============================================================

  final RxList<SpecialDealsModel> specialDeals =
      <SpecialDealsModel>[].obs;

  //============================================================
  // FAVORITE DEALS
  //============================================================

  final RxList<SpecialDealsModel> favoriteDeals =
      <SpecialDealsModel>[].obs;

  int get totalFavorites =>
      favoriteDeals.length;

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = false.obs;

  //============================================================
  // ERROR
  //============================================================

  final RxString errorMessage = ''.obs;

  //============================================================
  // INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    loadSpecialDeals();
  }

  //============================================================
  // LOAD SPECIAL DEALS
  //============================================================

  Future<void> loadSpecialDeals() async {
    //==========================================================
    // PREVENT DUPLICATE REQUESTS
    //==========================================================

    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      //========================================================
      // GET ACTIVE DEALS
      //========================================================

      final List<SpecialDealsModel> dealList =
          await _specialDealService
              .getActiveSpecialDeals();

      //========================================================
      // UPDATE CACHE
      //========================================================

      specialDeals.assignAll(dealList);
    } catch (e) {
      errorMessage.value =
          'Unable to load special deals.';

      print(
        'Special deals loading error: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  //============================================================
  // REFRESH
  //============================================================

  Future<void> refreshSpecialDeals() async {
    await loadSpecialDeals();
  }

  //============================================================
  // FEATURED DEALS
  //============================================================

  List<SpecialDealsModel> get featuredDeals {
    return specialDeals
        .where(
          (deal) => deal.isFeatured,
        )
        .toList(growable: false);
  }

  //============================================================
  // CHEF SPECIAL DEALS
  //============================================================

  List<SpecialDealsModel> get chefSpecialDeals {
    return specialDeals
        .where(
          (deal) => deal.isChefSpecial,
        )
        .toList(growable: false);
  }

  //============================================================
  // TOP SPECIAL DEALS
  //============================================================

  List<SpecialDealsModel> get topSpecialDeals {
    return specialDeals
        .take(10)
        .toList(growable: false);
  }

  //============================================================
  // TOP FEATURED DEALS
  //============================================================

  List<SpecialDealsModel> get topFeaturedDeals {
    return specialDeals
        .where(
          (deal) => deal.isFeatured,
        )
        .take(10)
        .toList(growable: false);
  }

  //============================================================
  // TOP CHEF SPECIAL DEALS
  //============================================================

  List<SpecialDealsModel> get topChefSpecialDeals {
    return specialDeals
        .where(
          (deal) => deal.isChefSpecial,
        )
        .take(10)
        .toList(growable: false);
  }

  //============================================================
  // TOGGLE FAVORITE
  //============================================================

  void toggleFavorite(
    SpecialDealsModel deal,
  ) {
    deal.isFavorite.value =
        !deal.isFavorite.value;

    if (deal.isFavorite.value) {
      if (!favoriteDeals.contains(deal)) {
        favoriteDeals.add(deal);
      }
    } else {
      favoriteDeals.remove(deal);
    }
  }
}