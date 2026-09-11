// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class ReviewSummaryCard extends StatelessWidget {
  ReviewSummaryCard({
    super.key,
  });

  final AppReviewController reviewController =
      Get.find<AppReviewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //==========================================================
      // TOTAL REVIEWS
      //==========================================================

      final int total =
    reviewController.totalReviews;

      //==========================================================
      // AVERAGE RATING
      //==========================================================

      final double average =
          reviewController.averageRating;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [
            //====================================================
            // AVERAGE RATING
            //====================================================

            Text(
              average.toStringAsFixed(1),
              style: GoogleFonts.poppins(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            //====================================================
            // STARS
            //====================================================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Icon(
                  index < average.round()
                      ? Icons.star
                      : Icons.star_border,
                  color:
                      AppColors.primary,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            //====================================================
            // TOTAL
            //====================================================

            Text(
              "Based on $total Reviews",
              style:
                  AppTextTheme.bodyText,
            ),

            const SizedBox(
              height: 25,
            ),

            //====================================================
            // 5 STAR
            //====================================================

            _ratingRow(
              "5",
              reviewController
                  .ratingCount(5),
              total,
            ),

            const SizedBox(
              height: 10,
            ),

            //====================================================
            // 4 STAR
            //====================================================

            _ratingRow(
              "4",
              reviewController
                  .ratingCount(4),
              total,
            ),

            const SizedBox(
              height: 10,
            ),

            //====================================================
            // 3 STAR
            //====================================================

            _ratingRow(
              "3",
              reviewController
                  .ratingCount(3),
              total,
            ),

            const SizedBox(
              height: 10,
            ),

            //====================================================
            // 2 STAR
            //====================================================

            _ratingRow(
              "2",
              reviewController
                  .ratingCount(2),
              total,
            ),

            const SizedBox(
              height: 10,
            ),

            //====================================================
            // 1 STAR
            //====================================================

            _ratingRow(
              "1",
              reviewController
                  .ratingCount(1),
              total,
            ),
          ],
        ),
      );
    });
  }

  //============================================================
  // RATING ROW
  //============================================================

  Widget _ratingRow(
    String star,
    int count,
    int total,
  ) {
    final double value =
        total == 0
            ? 0.0
            : count / total;

    return Row(
      children: [
        Text(
          star,
          style: GoogleFonts.poppins(
            fontWeight:
                FontWeight.w600,
          ),
        ),

        const SizedBox(
          width: 4,
        ),

        const Icon(
          Icons.star,
          color: AppColors.primary,
          size: 18,
        ),

        const SizedBox(
          width: 12,
        ),

        Expanded(
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(
              100,
            ),
            child:
                LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor:
                  Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation(
                AppColors.primary,
              ),
            ),
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        SizedBox(
          width: 25,
          child: Text(
            count.toString(),
            textAlign:
                TextAlign.end,
            style:
                GoogleFonts.poppins(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}