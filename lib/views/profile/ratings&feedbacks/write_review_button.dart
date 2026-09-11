// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';

class WriteReviewButton extends StatelessWidget {
  WriteReviewButton({super.key});

  final AppReviewController reviewController =
      Get.find<AppReviewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool hasReviewed =
          reviewController.hasMyReview;

      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(100),
            ),
          ),

          onPressed: () {
            if (hasReviewed) {
              Get.toNamed(
                AppRoutes.writeAppReview,
                arguments:
                    reviewController.myReview.value,
              );
            } else {
              Get.toNamed(
                AppRoutes.writeAppReview,
              );
            }
          },

          icon: Icon(
            hasReviewed
                ? Icons.edit
                : Icons.rate_review,
            size: 22,
          ),

          label: Text(
            hasReviewed
                ? "Edit Your Review"
                : "Write Your Review",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }
}