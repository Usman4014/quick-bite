// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/views/landing/home/special_deals/deal_add_to_cart_button.dart';
import 'package:quick_bite/views/landing/home/special_deals/deal_appbar.dart';
import 'package:quick_bite/views/landing/home/special_deals/deal_image.dart';
import 'package:quick_bite/views/landing/home/special_deals/deal_info.dart';
import 'package:quick_bite/views/landing/home/special_deals/deal_items.dart';
import 'package:quick_bite/views/landing/home/special_deals/deal_reviews.dart';

class SpecialDealsDetailsScreen extends StatelessWidget {
  SpecialDealsDetailsScreen({super.key});

  final SpecialDealsModel deal = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            DealImage(deal: deal),

            DealAppBar(deal: deal),

            _Body(deal: deal),

            DealAddToCartButton(deal: deal),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final SpecialDealsModel deal;

  const _Body({required this.deal});

  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController = Get.find<ReviewController>();

    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      //========================================================
      // DEAL REVIEW DATA
      //========================================================

      final double rating = reviewController.getAverageRatingForDeal(deal.id);

      final int totalReviews = reviewController.getTotalReviewsForDeal(deal.id);

      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height * .60,
            width: width,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade600, blurRadius: 100),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    //================================================
                    // TITLE + PRICE
                    //================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            deal.title,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        Text(
                          "\$${deal.dealPrice.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    //================================================
                    // RATING
                    //================================================
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          rating.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const SizedBox(width: 5),

                        Text(
                          "($totalReviews)",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    //================================================
                    // DESCRIPTION
                    //================================================
                    Text(
                      deal.description,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    //================================================
                    // DIVIDER
                    //================================================
                    Container(
                      height: 1.5,
                      width: width,
                      color: Colors.grey.shade200,
                    ),

                    const SizedBox(height: 30),

                    //================================================
                    // INCLUDED ITEMS
                    //================================================
                    DealItems(deal: deal),

                    const SizedBox(height: 30),

                    Container(
                      height: 1.5,
                      width: width,
                      color: Colors.grey.shade200,
                    ),

                    const SizedBox(height: 30),

                    //================================================
                    // DEAL INFO
                    //================================================
                    DealInfo(deal: deal),

                    const SizedBox(height: 30),

                    Container(
                      height: 1.5,
                      width: width,
                      color: Colors.grey.shade200,
                    ),

                    const SizedBox(height: 30),

                    //================================================
                    // REVIEWS
                    //================================================
                    DealReviews(deal: deal),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
