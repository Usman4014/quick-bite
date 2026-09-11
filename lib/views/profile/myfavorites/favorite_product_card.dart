// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/snack_bar.dart';


class FavoriteProductCard extends StatelessWidget {
  final ProductModel product;

  FavoriteProductCard({super.key, required this.product});

  final ProductController productController = Get.find<ProductController>();

  final ReviewController reviewController = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    final rating = reviewController.getAverageRatingForProduct(product.id);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Get.toNamed(AppRoutes.productdetailsscreen, arguments: product);
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
              Padding(
                padding: const EdgeInsets.only(left: 9),
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.network(
                    product.image,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                    cacheWidth: 260,
                    cacheHeight: 260,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.fastfood_outlined, size: 35);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.titleText,
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              productController.toggleFavorite(product);

                              Snack_Bar.show(
                                title: product.isFavorite.value
                                    ? "Added to Favorites"
                                    : "Removed from Favorites",
                                message: product.isFavorite.value
                                    ? "${product.name} has been added to favorites"
                                    : "${product.name} has been removed from favorites",
                                icon: product.isFavorite.value
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Center(
                                child: Obx(
                                  () => FaIcon(
                                    product.isFavorite.value
                                        ? FontAwesomeIcons.solidHeart
                                        : FontAwesomeIcons.heart,
                                    color: product.isFavorite.value
                                        ? AppColors.primary
                                        : Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText,
                      ),

                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${product.variants.first.price}",
                            style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),

                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.solidStar,
                                size: 12,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(rating.toStringAsFixed(1)),
                            ],
                          ),

                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: Text(
                                "Add",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
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
  }
}
