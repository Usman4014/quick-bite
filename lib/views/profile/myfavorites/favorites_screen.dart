// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/myfavorites/empty_favorites.dart';
import 'package:quick_bite/views/profile/myfavorites/favorite_product_card.dart';
import 'package:quick_bite/views/profile/myfavorites/favorite_special_deal_card.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/shimmers/favorites_shimmer.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});

  final ProductController productController = Get.find<ProductController>();
  final SpecialDealsController specialDealsController =
      Get.find<SpecialDealsController>();
  final ReviewController reviewController = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(children: [AppBar()]),
            SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                final bool isLoading =
                    productController.isLoading.value ||
                    specialDealsController.isLoading.value;

                if (isLoading) {
                  return const FavoritesShimmer();
                }

                final favoriteProducts = productController.favoriteProducts;
                final favoriteDeals = specialDealsController.favoriteDeals;

                final allFavorites = [...favoriteProducts, ...favoriteDeals];

                if (allFavorites.isEmpty) {
                  return EmptyFavorite();
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: allFavorites.length,
                  itemBuilder: (context, index) {
                    final item = allFavorites[index];

                    if (item is ProductModel) {
                      return FavoriteProductCard(product: item);
                    }

                    if (item is SpecialDealsModel) {
                      return FavoriteSpecialDealCard(deal: item);
                    }

                    return const SizedBox.shrink();
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget AppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),
            SizedBox(width: 15),
            Text('My Favorites', style: AppTextTheme.appbarText),
          ],
        ),
      ),
    );
  }
}
