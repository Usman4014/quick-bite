// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/models/Review_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class WriteReviewDialog extends StatefulWidget {
  final String productId;

  // null = create
  // review = edit
  final ReviewModel? review;

  const WriteReviewDialog({
    super.key,
    required this.productId,
    this.review,
  });

  @override
  State<WriteReviewDialog> createState() =>
      _WriteReviewDialogState();
}

class _WriteReviewDialogState
    extends State<WriteReviewDialog> {
  //============================================================
  // CONTROLLER
  //============================================================

  final ReviewController reviewController =
      Get.find<ReviewController>();

  //============================================================
  // TEXT
  //============================================================

  final TextEditingController _commentController =
      TextEditingController();

  //============================================================
  // RATING
  //============================================================

  double _rating = 5;

  //============================================================
  // EDIT MODE
  //============================================================

  bool get isEditing =>
      widget.review != null;

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    if (widget.review != null) {
      _rating = widget.review!.rating;
      _commentController.text =
          widget.review!.comment;
    }
  }

  //============================================================
  // DISPOSE
  //============================================================

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  //============================================================
  // SAVE REVIEW
  //============================================================

  Future<void> _saveReview() async {
    final User? firebaseUser =
        FirebaseAuth.instance.currentUser;

    //==========================================================
    // AUTHENTICATION
    //==========================================================

    if (firebaseUser == null) {
      Get.snackbar(
        'Login Required',
        'Please log in before submitting a review.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    //==========================================================
    // COMMENT
    //==========================================================

    final String comment =
        _commentController.text.trim();

    if (comment.isEmpty) {
      Get.snackbar(
        'Review Required',
        'Please write a review.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    //==========================================================
    // EDIT
    //==========================================================

    if (isEditing) {
      final bool success =
          await reviewController.updateReview(
        reviewId: widget.review!.id,
        rating: _rating,
        comment: comment,
      );

      if (!mounted) {
        return;
      }

      if (success) {
        Navigator.of(context).pop();

        Get.snackbar(
          'Review Updated',
          'Your review has been updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      Get.snackbar(
        'Unable to Update',
        reviewController.errorMessage.value.isNotEmpty
            ? reviewController.errorMessage.value
            : 'Unable to update your review.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    //==========================================================
    // CREATE
    //==========================================================

    final bool success =
        await reviewController.addReview(
      userId: firebaseUser.uid,
      productId: widget.productId,
      rating: _rating,
      comment: comment,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();

      Get.snackbar(
        'Review Submitted',
        'Thank you for reviewing this product.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return;
    }

    Get.snackbar(
      'Unable to Submit',
      reviewController.errorMessage.value.isNotEmpty
          ? reviewController.errorMessage.value
          : 'Unable to submit your review.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing
            ? 'Edit Your Review'
            : 'Write a Review',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            //==================================================
            // RATING
            //==================================================

            Text(
              'Your Rating',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) {
                  final int star =
                      index + 1;

                  return IconButton(
                    onPressed: () {
                      setState(() {
                        _rating =
                            star.toDouble();
                      });
                    },
                    icon: Icon(
                      star <= _rating
                          ? Icons.star
                          : Icons.star_border,
                      size: 34,
                      color:
                          AppColors.primary,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 5),

            Center(
              child: Text(
                '${_rating.toInt()} / 5',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color:
                      Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            //==================================================
            // COMMENT
            //==================================================

            Text(
              'Your Review',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller:
                  _commentController,
              maxLines: 5,
              maxLength: 500,
              decoration:
                  InputDecoration(
                hintText:
                    'Tell us what you think...',
                hintStyle:
                    GoogleFonts.poppins(
                  fontSize: 13,
                  color:
                      Colors.grey.shade500,
                ),
                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                focusedBorder:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                  borderSide:
                      const BorderSide(
                    color:
                        AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      //========================================================
      // ACTIONS
      //========================================================

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.poppins(
              color: Colors.black,
            ),
          ),
        ),

        Obx(
          () => ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor:
                  Colors.black,
            ),
            onPressed:
                reviewController
                        .isSaving
                        .value
                    ? null
                    : _saveReview,
            child:
                reviewController
                        .isSaving
                        .value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEditing
                            ? 'Update'
                            : 'Submit',
                        style:
                            GoogleFonts
                                .poppins(
                          fontWeight:
                              FontWeight
                                  .w600,
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}