// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/models/Review_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/models/User_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/special_deals/write_deal_review_dialog.dart';

class DealReviews extends StatefulWidget {
  final SpecialDealsModel deal;

  const DealReviews({super.key, required this.deal});

  @override
  State<DealReviews> createState() => _DealReviewsState();
}

class _DealReviewsState extends State<DealReviews> {
  //============================================================
  // CONTROLLER
  //============================================================

  late final ReviewController reviewController;

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    reviewController = Get.find<ReviewController>();

    reviewController.loadSpecialDealReviews(widget.deal.id);
  }

  //============================================================
  // OPEN WRITE REVIEW
  //============================================================

  void _openWriteReview() {
    Get.dialog(WriteDealReviewDialog(specialDealId: widget.deal.id));
  }

  //============================================================
  // OPEN EDIT REVIEW
  //============================================================

  void _openEditReview(ReviewModel review) {
    Get.dialog(
      WriteDealReviewDialog(specialDealId: widget.deal.id, review: review),
    );
  }

  //============================================================
  // DELETE REVIEW
  //============================================================

  Future<void> _deleteReview(ReviewModel review) async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'Delete Review?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),

        content: Text(
          'Are you sure you want to delete your review?',
          style: GoogleFonts.poppins(),
        ),

        actions: [
          //====================================================
          // CANCEL
          //====================================================

          TextButton(
            onPressed: () {
              Get.back(result: false);
            },

            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
          ),

          //====================================================
          // DELETE
          //====================================================
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },

            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final bool success = await reviewController.deleteReview(review.id);

    if (!success) {
      Get.snackbar(
        'Unable to Delete',
        reviewController.errorMessage.value.isNotEmpty
            ? reviewController.errorMessage.value
            : 'Unable to delete your review.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.snackbar(
      'Review Deleted',
      'Your review has been deleted successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //========================================================
      // ALL REVIEWS
      //========================================================

      final List<ReviewModel> allReviews = reviewController.getReviewsByDeal(
        widget.deal.id,
      );

      //========================================================
      // CURRENT USER
      //========================================================

      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

      //========================================================
      // MY REVIEW
      //========================================================

      ReviewModel? myReview;

      if (currentUserId != null) {
        myReview = reviewController.getUserSpecialDealReview(
          currentUserId,
          widget.deal.id,
        );
      }

      //========================================================
      // OTHER CUSTOMERS' REVIEWS
      //========================================================

      final List<ReviewModel> customerReviews = allReviews
          .where((review) => review.userId != currentUserId)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          //======================================================
          // HEADER
          //======================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text("Reviews", style: AppTextTheme.button),

              GestureDetector(
                onTap: () {
                  _showAllReviews(context, customerReviews);
                },

                child: Text("See All", style: AppTextTheme.textButton),
              ),
            ],
          ),

          const SizedBox(height: 15),

          //======================================================
          // MY REVIEW
          //======================================================
          if (myReview != null) ...[
            Text("Your Review", style: AppTextTheme.titleText),

            const SizedBox(height: 12),

            _ReviewItem(
              key: ValueKey('my_${myReview.id}'),

              review: myReview,

              reviewController: reviewController,

              isMyReview: true,

              onEdit: () {
                _openEditReview(myReview!);
              },

              onDelete: () {
                _deleteReview(myReview!);
              },
            ),

            const SizedBox(height: 25),
          ],

          //======================================================
          // WRITE REVIEW
          //======================================================
          if (myReview == null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),

              child: SizedBox(
                width: double.infinity,

                height: 48,

                child: OutlinedButton.icon(
                  onPressed: _openWriteReview,

                  //================================================
                  // EXACT PRODUCT REVIEW BUTTON STYLE
                  //================================================
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
                    Icons.rate_review_outlined,

                    color: AppColors.primary,
                  ),

                  label: Text(
                    'Write a Review',

                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

          //======================================================
          // CUSTOMER REVIEWS
          //======================================================
          if (customerReviews.isNotEmpty) ...[
            Text("Customer Reviews", style: AppTextTheme.titleText),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              itemCount: customerReviews.length > 5
                  ? 5
                  : customerReviews.length,

              itemBuilder: (context, index) {
                final ReviewModel review = customerReviews[index];

                return _ReviewItem(
                  key: ValueKey(review.id),

                  review: review,

                  reviewController: reviewController,

                  isMyReview: false,
                );
              },
            ),
          ]
          //======================================================
          // NO REVIEWS
          //======================================================
          else if (myReview == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),

              child: Text(
                "No reviews yet.",

                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      );
    });
  }

  //============================================================
  // SEE ALL
  //============================================================

  void _showAllReviews(BuildContext context, List<ReviewModel> reviews) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.75,

        decoration: const BoxDecoration(
          color: AppColors.background,

          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),

        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              //================================================
              // HANDLE
              //================================================
              Container(
                width: 50,
                height: 5,

                decoration: BoxDecoration(
                  color: Colors.grey.shade400,

                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              const SizedBox(height: 20),

              //================================================
              // HEADER
              //================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: Row(
                  children: [
                    Text(
                      "Reviews",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        Get.back();
                      },

                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(),

              //================================================
              // ALL REVIEWS
              //================================================
              Expanded(
                child: reviews.isEmpty
                    ? Center(
                        child: Text(
                          "No reviews yet.",
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),

                        padding: const EdgeInsets.all(20),

                        itemCount: reviews.length,

                        itemBuilder: (context, index) {
                          return _ReviewItem(
                            review: reviews[index],

                            reviewController: reviewController,

                            isMyReview: false,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }
}

//================================================================
// REVIEW ITEM
//================================================================

class _ReviewItem extends StatefulWidget {
  final ReviewModel review;

  final ReviewController reviewController;

  final bool isMyReview;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const _ReviewItem({
    super.key,

    required this.review,

    required this.reviewController,

    required this.isMyReview,

    this.onEdit,

    this.onDelete,
  });

  @override
  State<_ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<_ReviewItem> {
  UserModel? user;

  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  Future<void> _loadUser() async {
    final UserModel? loadedUser = await widget.reviewController.getReviewUser(
      widget.review.userId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      user = loadedUser;

      isLoadingUser = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                //================================================
                // PROFILE IMAGE
                //================================================

                if (isLoadingUser)
                  const _ProfileImagePlaceholder()
                else
                  _ProfileImage(imageUrl: user?.profileImage),

                const SizedBox(width: 15),

                //================================================
                // CONTENT
                //================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        user?.name.trim().isNotEmpty == true
                            ? user!.name
                            : "Customer",

                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        _formatDateTime(widget.review.createdAt),

                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 5),

                      //================================================
                      // STARS
                      //================================================
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < widget.review.rating.round()
                                ? Icons.star
                                : Icons.star_border,

                            size: 16,

                            color: AppColors.primary,
                          );
                        }),
                      ),

                      const SizedBox(height: 4),

                      //================================================
                      // COMMENT
                      //================================================
                      Text(
                        widget.review.comment,

                        maxLines: 3,

                        overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //====================================================
            // EDIT + DELETE
            //====================================================
            if (widget.isMyReview) ...[
              const SizedBox(height: 15),

              Row(
                children: [
                  //================================================
                  // EDIT BUTTON
                  //================================================

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.onEdit,

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

                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  //================================================
                  // DELETE BUTTON
                  //================================================
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: widget.onDelete,

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

                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  //============================================================
  // DATE
  //============================================================

  String _formatDateTime(DateTime dateTime) {
    final String month = _monthName(dateTime.month);

    final String day = dateTime.day.toString();

    final String year = dateTime.year.toString();

    final int hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;

    final String minute = dateTime.minute.toString().padLeft(2, '0');

    final String period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year • '
        '$hour:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month];
  }
}

//================================================================
// PROFILE IMAGE
//================================================================

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (!hasImage) {
      return const _ProfileImagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(100),

      child: Image.network(
        imageUrl!,

        width: 50,
        height: 50,

        fit: BoxFit.cover,

        errorBuilder: (context, error, stackTrace) {
          return const _ProfileImagePlaceholder();
        },
      ),
    );
  }
}

//================================================================
// PROFILE PLACEHOLDER
//================================================================

class _ProfileImagePlaceholder extends StatelessWidget {
  const _ProfileImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),

      child: Container(
        width: 50,
        height: 50,

        color: Colors.grey.shade200,

        child: const Icon(Icons.person, color: Colors.grey, size: 28),
      ),
    );
  }
}
