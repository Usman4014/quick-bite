// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/ratings&feedbacks/app_review_card.dart';
import 'package:quick_bite/views/profile/ratings&feedbacks/review_summary_card.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/shimmers/ratings_feedbacks_shimmer.dart';

class Ratings_Feedbacks_Screen extends StatefulWidget {
  const Ratings_Feedbacks_Screen({super.key});

  @override
  State<Ratings_Feedbacks_Screen> createState() =>
      _Ratings_Feedbacks_ScreenState();
}

class _Ratings_Feedbacks_ScreenState extends State<Ratings_Feedbacks_Screen> {
  final AppReviewController reviewController = Get.find<AppReviewController>();

  @override
  void initState() {
    super.initState();

    //==========================================================
    // LOAD ALL PUBLIC REVIEWS
    //==========================================================

    reviewController.loadAppReviews();

    //==========================================================
    // LOAD CURRENT USER REVIEW
    //==========================================================

    final UserController userController = Get.find<UserController>();

    final String? userId = userController.firebaseUid;

    if (userId != null) {
      reviewController.loadMyReview(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //========================================================
      // WRITE / EDIT REVIEW BUTTON
      //========================================================
      floatingActionButton: Obx(() {
        final bool hasReview = reviewController.hasMyReview;

        // If customer already reviewed,
        // don't show the floating button.
        if (hasReview) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          elevation: 0,
          onPressed: () {
            Get.toNamed(AppRoutes.writeAppReview);
          },
          icon: const Icon(Icons.rate_review_outlined),
          label: const Text("Write Review"),
        );
      }),

      //========================================================
      // BODY
      //========================================================
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            App_Bar(),

            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                //================================================
                // LOADING
                //================================================

                if (reviewController.isLoading.value) {
                  return const RatingsFeedbacksShimmer();
                }

                //================================================
                // ERROR
                //================================================

                if (reviewController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        reviewController.errorMessage.value,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                //================================================
                // CONTENT
                //================================================

                return ListView(
                  physics: const BouncingScrollPhysics(),

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  children: [
                    //================================================
                    // REVIEW SUMMARY
                    //================================================

                    ReviewSummaryCard(),

                    const SizedBox(height: 25),

                    //================================================
                    // YOUR REVIEW
                    //================================================
                    Text("Your Review", style: AppTextTheme.titleText),

                    const SizedBox(height: 15),

                    _buildMyReview(),

                    const SizedBox(height: 30),

                    //================================================
                    // CUSTOMER REVIEWS
                    //================================================
                    Text("Customer Reviews", style: AppTextTheme.titleText),

                    const SizedBox(height: 15),

                    //================================================
                    // NO REVIEWS
                    //================================================
                    if (reviewController.appReviews.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            "No reviews yet",
                            style: AppTextTheme.caption,
                          ),
                        ),
                      ),

                    //================================================
                    // ALL CUSTOMER REVIEWS
                    //================================================
                    ...reviewController.appReviews
                        .where(
                          (review) =>
                              review.userId !=
                              reviewController.myReview.value?.userId,
                        )
                        .map(
                          (review) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: AppReviewCard(review: review),
                          ),
                        ),

                    const SizedBox(height: 100),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // YOUR REVIEW
  //============================================================

  Widget _buildMyReview() {
    final review = reviewController.myReview.value;

    //==========================================================
    // CUSTOMER HAS NOT REVIEWED
    //==========================================================

    if (review == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 40,
              color: AppColors.primary,
            ),

            const SizedBox(height: 12),

            Text(
              "You haven't reviewed Quick Bite yet.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 15),
          ],
        ),
      );
    }

    //==========================================================
    // CUSTOMER HAS REVIEWED
    //==========================================================

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //======================================================
          // USER + RATING
          //======================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //==================================================
              // PROFILE IMAGE
              //==================================================

              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),

                backgroundImage:
                    reviewController
                            .getCachedReviewUser(review.userId)
                            ?.profileImage !=
                        null
                    ? NetworkImage(
                        reviewController
                            .getCachedReviewUser(review.userId)!
                            .profileImage!,
                      )
                    : null,

                child:
                    reviewController
                            .getCachedReviewUser(review.userId)
                            ?.profileImage ==
                        null
                    ? const Icon(Icons.person, color: AppColors.primary)
                    : null,
              ),

              const SizedBox(width: 12),

              //==================================================
              // NAME + DATE
              //==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewController
                              .getCachedReviewUser(review.userId)
                              ?.name ??
                          "You",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      _formatDate(review.createdAt),
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              //==================================================
              // RATING
              //==================================================
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          //======================================================
          // COMMENT
          //======================================================
          Text(
            review.comment,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 18),

          //======================================================
          // EDIT + DELETE
          //======================================================
          Row(
            children: [
              //========================================================
              // EDIT
              //========================================================

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.toNamed(AppRoutes.writeAppReview, arguments: review);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    "Edit",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              //========================================================
              // DELETE
              //========================================================
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showDeleteDialog(review.id);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    "Delete",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //============================================================
  // DELETE CONFIRMATION
  //============================================================

  void _showDeleteDialog(String reviewId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Delete Review?",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),

        content: Text(
          "Are you sure you want to delete your review?",
          style: GoogleFonts.poppins(),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () async {
              Get.back();

              final success = await reviewController.deleteReview(reviewId);

              if (success) {
                Get.snackbar(
                  "Review Deleted",
                  "Your review has been deleted successfully.",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  //============================================================
  // DATE FORMAT
  //============================================================

  String _formatDate(DateTime date) {
    final difference = DateTime.now().difference(date);

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

  //============================================================
  // APP BAR
  //============================================================

  Widget App_Bar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),

            const SizedBox(width: 15),

            Text('Ratings & Feedback', style: AppTextTheme.appbarText),
          ],
        ),
      ),
    );
  }
}
