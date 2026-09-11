// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/models/Chef_Special_Model.dart';

class ChefSpecialController extends GetxController {
  //============================================================
  // PRODUCT CONTROLLER
  //============================================================

  final ProductController productController = Get.find<ProductController>();

  //============================================================
  // SPECIAL DEALS CONTROLLER
  //============================================================

  final SpecialDealsController specialDealsController =
      Get.find<SpecialDealsController>();

  //============================================================
  // ALL CHEF SPECIALS
  //============================================================

  final RxList<ChefSpecialModel> chefSpecials = <ChefSpecialModel>[].obs;

  //============================================================
  // LOADING STATE
  //============================================================

  final RxBool isLoading = true.obs;

  //============================================================
  // CURRENT FEATURED ITEM
  //============================================================

  final RxInt currentIndex = 0.obs;

  final PageController pageController = PageController(viewportFraction: 1);

  Timer? _timer;

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

    loadChefSpecials();

    //==========================================================
    // LISTEN TO PRODUCT CHANGES
    //==========================================================

    _productsWorker = ever(productController.products, (_) {
      loadChefSpecials();
    });
    _productsWorker = ever(productController.products, (_) {
      loadChefSpecials();
    });

    _productsLoadingWorker = ever(productController.isLoading, (_) {
      loadChefSpecials();
    });

    //==========================================================
    // LISTEN TO SPECIAL DEAL CHANGES
    //==========================================================

    _dealsWorker = ever(specialDealsController.specialDeals, (_) {
      loadChefSpecials();
    });

    _dealsWorker = ever(specialDealsController.specialDeals, (_) {
      loadChefSpecials();
    });

    _dealsLoadingWorker = ever(specialDealsController.isLoading, (_) {
      loadChefSpecials();
    });

    print('Current Item: ${currentChefSpecial?.title}');

    startAutoRotation();
  }

  //============================================================
  // CLOSE
  //============================================================

  @override
  void onClose() {
    _timer?.cancel();

    _productsWorker?.dispose();
    _productsLoadingWorker?.dispose();

    _dealsWorker?.dispose();
    _dealsLoadingWorker?.dispose();

    pageController.dispose();

    super.onClose();
  }
  //============================================================
  // LOAD CHEF SPECIALS
  //============================================================

  void loadChefSpecials() {
    //==========================================================
    // WAIT FOR SOURCE DATA
    //==========================================================

    final bool productsLoading = productController.isLoading.value;

    final bool dealsLoading = specialDealsController.isLoading.value;

    if (productsLoading || dealsLoading) {
      isLoading.value = true;
      return;
    }

    //==========================================================
    // START BUILDING LIST
    //==========================================================

    final List<ChefSpecialModel> items = [];

    //==========================================================
    // PRODUCTS FROM FIRESTORE
    //==========================================================

    for (final product in productController.products) {
      if (product.isChefSpecial) {
        items.add(ChefSpecialModel(product: product));
      }
    }

    //==========================================================
    // SPECIAL DEALS FROM FIRESTORE
    //==========================================================

    for (final deal in specialDealsController.specialDeals) {
      if (deal.isChefSpecial) {
        items.add(ChefSpecialModel(specialDeal: deal));
      }
    }

    //==========================================================
    // UPDATE LIST
    //==========================================================

    chefSpecials.assignAll(items);

    //==========================================================
    // KEEP CURRENT INDEX VALID
    //==========================================================

    if (chefSpecials.isEmpty) {
      currentIndex.value = 0;
    } else if (currentIndex.value >= chefSpecials.length) {
      currentIndex.value = 0;
    }

    //==========================================================
    // LOADING COMPLETE
    //==========================================================

    isLoading.value = false;

    print('Chef Specials Loaded: ${chefSpecials.length}');
  }

  //============================================================
  // CURRENT CHEF SPECIAL
  //============================================================

  ChefSpecialModel? get currentChefSpecial {
    if (chefSpecials.isEmpty) {
      return null;
    }

    return chefSpecials[currentIndex.value];
  }

  //============================================================
  // NEXT ITEM
  //============================================================

  void next() {
    if (chefSpecials.isEmpty) {
      return;
    }

    if (!pageController.hasClients) {
      return;
    }

    int nextIndex = currentIndex.value + 1;

    if (nextIndex >= chefSpecials.length) {
      nextIndex = 0;
    }

    currentIndex.value = nextIndex;

    pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //============================================================
  // PREVIOUS ITEM
  //============================================================

  void previous() {
    if (chefSpecials.isEmpty) {
      return;
    }

    if (!pageController.hasClients) {
      return;
    }

    int previousIndex = currentIndex.value - 1;

    if (previousIndex < 0) {
      previousIndex = chefSpecials.length - 1;
    }

    currentIndex.value = previousIndex;

    pageController.animateToPage(
      previousIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //============================================================
  // PAGE CHANGED
  //============================================================

  void onPageChanged(int index) {
    if (index < 0 || index >= chefSpecials.length) {
      return;
    }

    currentIndex.value = index;
  }

  //============================================================
  // AUTO ROTATION
  //============================================================

  void startAutoRotation() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      next();
    });
  }

  //============================================================
  // MANUAL REFRESH
  //============================================================

  void refreshChefSpecials() {
    loadChefSpecials();
  }
}
