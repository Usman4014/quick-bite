// ignore_for_file: avoid_print, file_names

import 'package:get/get.dart';

import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/services/Product_Service.dart';

class ProductController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final ProductService _productService = ProductService();

  //============================================================
  // USER CONTROLLER
  //============================================================

  final UserController userController = Get.find<UserController>();

  //============================================================
  // PRODUCTS
  //============================================================

  final RxList<ProductModel> products = <ProductModel>[].obs;

  //============================================================
  // FAVORITES
  //============================================================

  final RxList<ProductModel> favoriteProducts = <ProductModel>[].obs;

  int get totalFavorites => favoriteProducts.length;

  //============================================================
  // LIST LOADING
  //============================================================

  final RxBool isLoading = true.obs;

  //============================================================
  // PRODUCT DETAIL
  //============================================================

  final Rxn<ProductModel> selectedProduct = Rxn<ProductModel>();

  final RxBool isDetailLoading = true.obs;

  //============================================================
  // ERROR
  //============================================================

  final RxString errorMessage = ''.obs;

  final RxString detailErrorMessage = ''.obs;

  //============================================================
  // INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    loadProducts();
  }

  //============================================================
  // LOAD PRODUCTS
  //============================================================

  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final List<ProductModel> productList = await _productService
          .getActiveProducts();

      products.assignAll(productList);
    } catch (error) {
      errorMessage.value = 'Unable to load products.';

      print('Product loading error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  //============================================================
  // LOAD SINGLE PRODUCT FOR PRODUCT DETAILS
  //============================================================

  Future<void> loadProductById(String productId) async {
    try {
      //========================================================
      // START LOADING
      //========================================================

      isDetailLoading.value = true;
      detailErrorMessage.value = '';
      selectedProduct.value = null;

      //========================================================
      // FIRESTORE
      //========================================================

      final ProductModel? product = await _productService.getProductById(
        productId,
      );

      //========================================================
      // PRODUCT NOT FOUND
      //========================================================

      if (product == null) {
        detailErrorMessage.value = 'This product is no longer available.';
        return;
      }

      //========================================================
      // PRODUCT LOADED
      //========================================================

      selectedProduct.value = product;
    } catch (error) {
      detailErrorMessage.value = 'Unable to load product.';

      print('Product detail loading error: $error');
    } finally {
      //========================================================
      // FIRESTORE FINISHED
      //========================================================

      isDetailLoading.value = false;
    }
  }

  //============================================================
  // REFRESH PRODUCTS
  //============================================================

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  //============================================================
  // TOGGLE FAVORITE
  //============================================================

  void toggleFavorite(ProductModel product) {
    product.isFavorite.value = !product.isFavorite.value;

    if (product.isFavorite.value) {
      if (!favoriteProducts.contains(product)) {
        favoriteProducts.add(product);
      }
    } else {
      favoriteProducts.remove(product);
    }

    userController.currentUser.refresh();
  }

  //============================================================
  // SEARCH PRODUCTS
  //============================================================

  List<ProductModel> searchProducts(String query) {
    final String normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return products.toList();
    }

    return products.where((product) {
      final String name = product.name.toLowerCase();

      final String description = product.description.toLowerCase();

      final String category = product.category.toLowerCase();

      return name.contains(normalizedQuery) ||
          description.contains(normalizedQuery) ||
          category.contains(normalizedQuery);
    }).toList();
  }
}
