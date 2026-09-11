// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/shimmers/list_of_products_shimmer.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/controllers/Category_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class ListOfProducts extends StatelessWidget {
  ListOfProducts({super.key});

  final ProductController productController = Get.find<ProductController>();

  final ReviewController reviewController = Get.find<ReviewController>();

  final CategoryController categoryController = Get.find<CategoryController>();

  //============================================================
  // GET CATEGORY ID
  //============================================================

  String? _getCategoryId() {
    final arguments = Get.arguments;

    // Normal category navigation
    if (arguments is String) {
      return null;
    }

    // Offer navigation
    if (arguments is Map<String, dynamic>) {
      final value = arguments['categoryId'];

      if (value is String && value.isNotEmpty) {
        return value;
      }
    }

    return null;
  }

  //============================================================
  // GET CATEGORY NAME
  //============================================================

  String _getCategoryName() {
    final arguments = Get.arguments;

    // Normal category navigation
    if (arguments is String) {
      return arguments;
    }

    // Offer navigation
    if (arguments is Map<String, dynamic>) {
      final categoryId = arguments['categoryId'];

      if (categoryId is String && categoryId.isNotEmpty) {
        final category = categoryController.categories.firstWhereOrNull(
          (category) => category.id == categoryId,
        );

        return category?.name ?? '';
      }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            //====================================================
            // APP BAR
            //====================================================
            AppBar(),

            const SizedBox(height: 20),

            //====================================================
            // PRODUCTS
            //====================================================
            Expanded(
              child: Obx(() {
                //================================================
                // LOADING
                //================================================

                if (productController.isLoading.value) {
                  return const ListOfProductsShimmer();
                }

                //================================================
                // CATEGORY FILTERING
                //================================================

                final String searchQuery = _getSearchQuery();
                final String? categoryId = _getCategoryId();
                final String categoryName = _getCategoryName();

                final products = searchQuery.isNotEmpty
                    ? productController.searchProducts(searchQuery)
                    : categoryId != null
                    ? productController.products
                          .where((p) => p.categoryId == categoryId)
                          .toList()
                    : productController.products
                          .where((p) => p.category == categoryName)
                          .toList();

                //================================================
                // EMPTY STATE
                //================================================

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                //================================================
                // PRODUCT LIST
                //================================================

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    final rating = reviewController.getAverageRatingForProduct(
                      product.id,
                    );

                    final totalReviews = reviewController
                        .getTotalReviewsForProduct(product.id);

                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 15,
                      ),
                      child: InkWell(
                        splashColor: Colors.transparent,

                        //==========================================
                        // PRODUCT DETAILS
                        //==========================================
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.productdetailsscreen,
                            arguments: product,
                          );
                        },

                        child: Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Row(
                            children: [
                              //====================================
                              // PRODUCT IMAGE
                              //====================================

                              Padding(
                                padding: const EdgeInsets.only(left: 9),
                                child: Container(
                                  height: 115,
                                  width: 115,

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),

                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      _optimizedImageUrl(product.image),

                                      width: 115,
                                      height: 115,

                                      fit: BoxFit.cover,

                                      cacheWidth: 230,
                                      cacheHeight: 230,

                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.fastfood_outlined,
                                              size: 35,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                              ),

                              //====================================
                              // CONTENT
                              //====================================
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,

                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      //================================
                                      // TITLE + FAVORITE
                                      //================================

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,

                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 15,
                                              ),

                                              child: Text(
                                                product.name,

                                                overflow: TextOverflow.ellipsis,

                                                maxLines: 2,

                                                style: AppTextTheme.titleText,
                                              ),
                                            ),
                                          ),

                                          //==============================
                                          // FAVORITE
                                          //==============================
                                          Obx(
                                            () => GestureDetector(
                                              onTap: () {
                                                productController
                                                    .toggleFavorite(product);

                                                Snack_Bar.show(
                                                  title:
                                                      product.isFavorite.value
                                                      ? 'Added to Favorites'
                                                      : 'Removed from Favorites',

                                                  message:
                                                      product.isFavorite.value
                                                      ? '${product.name} has been added to favorites'
                                                      : '${product.name} has been removed from favorites',

                                                  icon: product.isFavorite.value
                                                      ? FontAwesomeIcons
                                                            .solidHeart
                                                      : FontAwesomeIcons.heart,
                                                );
                                              },

                                              child: Center(
                                                child: FaIcon(
                                                  product.isFavorite.value
                                                      ? FontAwesomeIcons
                                                            .solidHeart
                                                      : FontAwesomeIcons.heart,

                                                  color:
                                                      product.isFavorite.value
                                                      ? AppColors.primary
                                                      : Colors.grey.shade400,

                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      //================================
                                      // DESCRIPTION
                                      //================================
                                      Text(
                                        product.description,

                                        overflow: TextOverflow.ellipsis,

                                        maxLines: 2,

                                        style: AppTextTheme.caption,
                                      ),

                                      const SizedBox(height: 15),

                                      //================================
                                      // PRICE + RATING + ADD
                                      //================================
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,

                                        children: [
                                          //==============================
                                          // PRICE
                                          //==============================

                                          Text(
                                            '\$${product.variants[0].price}',

                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),

                                          //==============================
                                          // RATING
                                          //==============================
                                          Row(
                                            children: [
                                              FaIcon(
                                                FontAwesomeIcons.solidStar,
                                                size: 12,
                                                color: AppColors.primary,
                                              ),

                                              const SizedBox(width: 3),

                                              Text(rating.toStringAsFixed(1)),
                                            ],
                                          ),

                                          //==============================
                                          // ADD BUTTON
                                          //==============================
                                          SizedBox(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Get.toNamed(
                                                  AppRoutes
                                                      .productdetailsscreen,
                                                  arguments: product,
                                                );
                                              },

                                              icon: const Icon(
                                                Icons.add,
                                                size: 18,
                                              ),

                                              label: Text(
                                                'Add',

                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBar() {
    final searchQuery = _getSearchQuery();
    final categoryName = _getCategoryName();

    String title;

    if (searchQuery.isNotEmpty) {
      title = 'Search Results';
    } else {
      title = categoryName;
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),

            const SizedBox(width: 15),

            Expanded(
              child: Text(
                title,
                style: AppTextTheme.appbarText,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  //============================================================
  // OPTIMIZED CLOUDINARY IMAGE
  //============================================================

  String _optimizedImageUrl(String url) {
    if (url.isEmpty) {
      return url;
    }

    if (!url.contains('res.cloudinary.com')) {
      return url;
    }

    if (url.contains('/upload/')) {
      return url.replaceFirst(
        '/upload/',
        '/upload/f_auto,q_auto,w_230,h_230,c_fill/',
      );
    }

    return url;
  }

  String _getSearchQuery() {
    final arguments = Get.arguments;

    if (arguments is Map) {
      return arguments['searchQuery']?.toString() ?? '';
    }

    return '';
  }
}
