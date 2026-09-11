// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';

class AppRatingBottomSheet extends StatefulWidget {
  const AppRatingBottomSheet({super.key});

  @override
  State<AppRatingBottomSheet> createState() => _AppRatingBottomSheetState();
}

class _AppRatingBottomSheetState extends State<AppRatingBottomSheet> {
  int rating = 5;
  final UserController userController = Get.find<UserController>();
  final TextEditingController reviewTextController = TextEditingController();
  final AppReviewController appReviewController =
      Get.find<AppReviewController>();

  @override
  void dispose() {
    reviewTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //-----------------------------------
            // Handle
            //-----------------------------------
            Container(
              width: 55,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 25),

            Icon(Icons.star_rounded, size: 70, color: Colors.amber.shade600),

            const SizedBox(height: 15),

            Text(
              "Rate Quick Bite",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "How was your experience with Quick Bite?",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 25),

            //-----------------------------------
            // Stars
            //-----------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  splashRadius: 24,
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 38,
                    color: Colors.amber,
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            //-----------------------------------
            // Review Field
            //-----------------------------------
            TextField(
              controller: reviewTextController,
              maxLines: 4,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: "Write your review...",
                hintStyle: GoogleFonts.poppins(),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 25),

            //-----------------------------------
            // Submit
            //-----------------------------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: Obx(
                () => ElevatedButton(
                  onPressed: appReviewController.isSaving.value
                      ? null
                      : () async {
                          //================================================
                          // CURRENT USER
                          //================================================

                          final user = userController.currentUser.value;

                          if (user == null || user.id.trim().isEmpty) {
                            return;
                          }

                          //================================================
                          // COMMENT VALIDATION
                          //================================================

                          final comment = reviewTextController.text.trim();

                          if (comment.isEmpty) {
                            return;
                          }

                          //================================================
                          // CREATE APP REVIEW
                          //================================================

                          final bool success = await appReviewController
                              .addReview(
                                userId: user.id,
                                rating: rating.toDouble(),
                                comment: comment,
                              );

                          //================================================
                          // SUCCESS
                          //================================================

                          if (success) {
                            Get.back();
                          }
                        },

                  child: appReviewController.isSaving.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Submit Review",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
