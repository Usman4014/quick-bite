// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/models/AppReview_Model.dart';
import 'package:quick_bite/models/User_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class AppReviewCard extends StatelessWidget {
  final AppReviewModel review;

  const AppReviewCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final AppReviewController controller =
        Get.find<AppReviewController>();

    return Obx(() {
      final UserModel? user =
          controller.reviewUsers[review.userId];

      //========================================================
      // USER PROFILE NOT LOADED YET
      //========================================================

      if (user == null) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: const SizedBox(
            height: 80,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      }

      //========================================================
      // REVIEW CARD
      //========================================================

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            //==================================================
            // USER INFORMATION
            //==================================================

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                //================================================
                // PROFILE IMAGE
                //================================================

                CircleAvatar(
                  radius: 24,
                  backgroundColor:
                      AppColors.primary.withValues(
                    alpha: 0.2,
                  ),
                  child: user.profileImage != null &&
                          user.profileImage!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            user.profileImage!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return const Icon(
                                Icons.person,
                                color:
                                    AppColors.primary,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.primary,
                        ),
                ),

                const SizedBox(width: 12),

                //================================================
                // NAME + DATE
                //================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name.isNotEmpty
                            ? user.name
                            : "No Name",
                        style:
                            GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        _formatDate(
                          review.createdAt,
                        ),
                        style:
                            GoogleFonts.poppins(
                          color:
                              Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                //================================================
                // RATING
                //================================================

                Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index <
                              review.rating.round()
                          ? Icons.star
                          : Icons.star_border,
                      color:
                          AppColors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            //==================================================
            // COMMENT
            //==================================================

            Text(
              review.comment,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      );
    });
  }

  //============================================================
  // DATE FORMAT
  //============================================================

  String _formatDate(DateTime date) {
    final difference =
        DateTime.now().difference(date);

    if (difference.inDays == 0) {
      return "Today";
    }

    if (difference.inDays == 1) {
      return "1 day ago";
    }

    if (difference.inDays < 30) {
      return "${difference.inDays} days ago";
    }

    if (difference.inDays < 365) {
      return "${difference.inDays ~/ 30} months ago";
    }

    return "${difference.inDays ~/ 365} years ago";
  }
}