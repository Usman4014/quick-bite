// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class ProductHeader extends StatelessWidget {
  final ProductModel product;
  final ProductVariantModel selectedVariant;

  const ProductHeader({
    super.key,
    required this.product,
    required this.selectedVariant,
  });

 @override
Widget build(BuildContext context) {
  final ReviewController reviewController =
      Get.find<ReviewController>();

  return Obx(() {
    //============================================================
    // PRODUCT REVIEW RATING
    //============================================================

    final double rating =
        reviewController.getAverageRatingForProduct(
      product.id,
    );

    //============================================================
    // TOTAL PRODUCT REVIEWS
    //============================================================

    final int totalReviews =
        reviewController.getTotalReviewsForProduct(
      product.id,
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        //========================================================
        // PRODUCT NAME + PRICE
        //========================================================

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: GoogleFonts.poppins(
                  textStyle:
                      const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            Text(
              "\$${selectedVariant.price.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(
                  color:
                      AppColors.primary,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        //========================================================
        // RATING
        //========================================================

        Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.solidStar,
              size: 14,
              color:
                  AppColors.primary,
            ),

            const SizedBox(width: 4),

            Text(
              rating.toStringAsFixed(1),
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(width: 4),

            Text(
              "($totalReviews)",
              style: GoogleFonts.poppins(
                textStyle:
                    const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        //========================================================
        // DESCRIPTION
        //========================================================

        Text(
          product.description,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color:
                  Colors.grey.shade700,
              fontSize: 16,
            ),
          ),
        ),

        const SizedBox(height: 30),

        //========================================================
        // DIVIDER
        //========================================================

        Container(
          height: 1.5,
          width: double.infinity,
          color: Colors.grey.shade200,
        ),

        const SizedBox(height: 30),
      ],
    );
  });
}
}