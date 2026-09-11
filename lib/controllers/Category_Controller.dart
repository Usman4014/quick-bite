// ignore_for_file: file_names, avoid_print

import 'dart:async';

import 'package:get/get.dart';

import 'package:quick_bite/models/Category_Model.dart';
import 'package:quick_bite/services/Category_Service.dart';

class CategoryController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final CategoryService _categoryService = CategoryService();

  //============================================================
  // CATEGORIES
  //============================================================

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  //============================================================
  // STATE
  //============================================================

  final RxBool isLoading = true.obs;

  final RxString errorMessage = ''.obs;

  //============================================================
  // STREAM SUBSCRIPTION
  //============================================================

  StreamSubscription<List<CategoryModel>>? _categoriesSubscription;

  //============================================================
  // INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    listenToCategories();
  }

  //============================================================
  // LISTEN TO ACTIVE CATEGORIES
  //============================================================

  void listenToCategories() {
    //==========================================================
    // CANCEL PREVIOUS LISTENER
    //==========================================================

    _categoriesSubscription?.cancel();

    //==========================================================
    // START LOADING
    //==========================================================

    isLoading.value = true;
    errorMessage.value = '';

    //==========================================================
    // START LISTENER
    //==========================================================

    _categoriesSubscription =
        _categoryService.listenToCategories().listen(
      (List<CategoryModel> categoryList) {
        //======================================================
        // UPDATE CATEGORIES
        //======================================================

        categories.assignAll(categoryList);

        //======================================================
        // LOADING COMPLETE
        //======================================================

        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (error) {
        //======================================================
        // ERROR
        //======================================================

        isLoading.value = false;
        errorMessage.value = 'Unable to load categories.';

        print('Category listener error: $error');
      },
    );
  }

  //============================================================
  // DISPOSE
  //============================================================

  @override
  void onClose() {
    _categoriesSubscription?.cancel();

    _categoriesSubscription = null;

    super.onClose();
  }
}