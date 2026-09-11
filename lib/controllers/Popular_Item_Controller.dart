// ignore_for_file: avoid_print, file_names

import 'package:get/get.dart';

import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/models/Popular_Item_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

class PopularItemController extends GetxController {
  //============================================================
  // CONTROLLERS
  //============================================================

  final ProductController productController =
      Get.find<ProductController>();

  final SpecialDealsController specialDealsController =
      Get.find<SpecialDealsController>();

  //============================================================
  // POPULAR ITEMS
  //============================================================

  final RxList<PopularItemModel> popularItems =
      <PopularItemModel>[].obs;

  //============================================================
  // DERIVED LISTS
  //============================================================

  final RxList<PopularItemModel> topPopularItems =
      <PopularItemModel>[].obs;

  final RxList<PopularItemModel> topFivePopularItems =
      <PopularItemModel>[].obs;

  final RxList<PopularItemModel> popularProducts =
      <PopularItemModel>[].obs;

  final RxList<PopularItemModel> popularDeals =
      <PopularItemModel>[].obs;

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = true.obs;

  //============================================================
  // WORKERS
  //============================================================

  Worker? _productsWorker;
  Worker? _productsLoadingWorker;

  Worker? _dealsWorker;
  Worker? _dealsLoadingWorker;

  //============================================================
  // INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    // Build initial state.
    loadPopularItems();

    //==========================================================
    // PRODUCT LIST CHANGES
    //==========================================================

    _productsWorker = ever(
      productController.products,
      (_) {
        loadPopularItems();
      },
    );

    //==========================================================
    // PRODUCT LOADING CHANGES
    //==========================================================

    _productsLoadingWorker = ever(
      productController.isLoading,
      (_) {
        loadPopularItems();
      },
    );

    //==========================================================
    // SPECIAL DEAL LIST CHANGES
    //==========================================================

    _dealsWorker = ever(
      specialDealsController.specialDeals,
      (_) {
        loadPopularItems();
      },
    );

    //==========================================================
    // SPECIAL DEAL LOADING CHANGES
    //==========================================================

    _dealsLoadingWorker = ever(
      specialDealsController.isLoading,
      (_) {
        loadPopularItems();
      },
    );
  }

  //============================================================
  // LOAD POPULAR ITEMS
  //============================================================

  void loadPopularItems() {
    //==========================================================
    // WAIT UNTIL BOTH SOURCES FINISH LOADING
    //==========================================================

    final bool productsLoading =
        productController.isLoading.value;

    final bool dealsLoading =
        specialDealsController.isLoading.value;

    if (productsLoading || dealsLoading) {
      isLoading.value = true;
      return;
    }

    //==========================================================
    // BUILD LIST
    //==========================================================

    final List<PopularItemModel> items = [];

    //==========================================================
    // PRODUCTS
    //==========================================================

    for (final product in productController.products) {
      items.add(
        PopularItemModel(
          product: product,
        ),
      );
    }

    //==========================================================
    // SPECIAL DEALS
    //==========================================================

    for (final deal in specialDealsController.specialDeals) {
      items.add(
        PopularItemModel(
          specialDeal: deal,
        ),
      );
    }

    //==========================================================
    // SORT BY TOTAL ORDERS
    //==========================================================

    items.sort(
      (a, b) => b.totalOrders.compareTo(
        a.totalOrders,
      ),
    );

    //==========================================================
    // TOP 10
    //==========================================================

    final List<PopularItemModel> topItems =
        items.take(10).toList();

    //==========================================================
    // TOP 5
    //==========================================================

    final List<PopularItemModel> fiveItems =
        items.take(5).toList();

    //==========================================================
    // PRODUCTS ONLY
    //==========================================================

    final List<PopularItemModel> productItems =
        items.where(
          (item) => item.product != null,
        ).toList();

    //==========================================================
    // DEALS ONLY
    //==========================================================

    final List<PopularItemModel> dealItems =
        items.where(
          (item) => item.specialDeal != null,
        ).toList();

    //==========================================================
    // UPDATE OBSERVABLES
    //==========================================================

    popularItems.assignAll(items);

    topPopularItems.assignAll(topItems);

    topFivePopularItems.assignAll(fiveItems);

    popularProducts.assignAll(productItems);

    popularDeals.assignAll(dealItems);

    //==========================================================
    // LOADING COMPLETE
    //==========================================================

    isLoading.value = false;

    print(
      'Popular Items Loaded: ${popularItems.length}',
    );
    print(
      'Popular Products: ${popularProducts.length}',
    );
    print(
      'Popular Deals: ${popularDeals.length}',
    );
  }

  //============================================================
  // INCREASE PRODUCT ORDERS
  //============================================================

  void increaseProductOrders(
    ProductModel product, {
    int count = 1,
  }) {
    product.totalOrders += count;

    loadPopularItems();
  }

  //============================================================
  // INCREASE DEAL ORDERS
  //============================================================

  void increaseDealOrders(
    SpecialDealsModel deal, {
    int count = 1,
  }) {
    deal.totalOrders += count;

    loadPopularItems();
  }

  //============================================================
  // REFRESH
  //============================================================

  void refreshPopularItems() {
    loadPopularItems();
  }

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _productsWorker?.dispose();
    _productsLoadingWorker?.dispose();

    _dealsWorker?.dispose();
    _dealsLoadingWorker?.dispose();

    super.onClose();
  }
}