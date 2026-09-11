// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/models/AppReview_Model.dart';
import 'package:quick_bite/theme/App_Constants.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class WriteAppReviewScreen extends StatefulWidget {
  const WriteAppReviewScreen({super.key});

  @override
  State<WriteAppReviewScreen> createState() => _WriteAppReviewScreenState();
}

class _WriteAppReviewScreenState extends State<WriteAppReviewScreen> {
  //============================================================
  // CONTROLLERS
  //============================================================

  final AppReviewController reviewController = Get.find<AppReviewController>();

  final UserController userController = Get.find<UserController>();

  //============================================================
  // TEXT CONTROLLER
  //============================================================

  final TextEditingController reviewControllerText = TextEditingController();

  //============================================================
  // FORM
  //============================================================

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //============================================================
  // EDITING REVIEW
  //============================================================

  AppReviewModel? editingReview;

  //============================================================
  // RATING
  //============================================================

  double rating = 5;

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    final argument = Get.arguments;

    if (argument is AppReviewModel) {
      editingReview = argument;

      rating = argument.rating;

      reviewControllerText.text = argument.comment;
    }
  }

  //============================================================
  // DISPOSE
  //============================================================

  @override
  void dispose() {
    reviewControllerText.dispose();

    super.dispose();
  }

  Future<void> deleteMyReview() async {
    if (editingReview == null) {
      return;
    }

    final bool? confirmed = await Get.dialog<bool>(
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
              Get.back(result: false);
            },
            child: const Text("Cancel"),
          ),

          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    final bool success = await reviewController.deleteReview(editingReview!.id);

    if (!success) {
      Snack_Bar.show(
        title: "Error",
        message: reviewController.errorMessage.value,
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    Get.back();

    Snack_Bar.show(
      title: "Review Deleted",
      message: "Your review has been deleted successfully.",
      icon: FontAwesomeIcons.solidCircleCheck,
    );
  }

  //============================================================
  // SAVE REVIEW
  //============================================================

  Future<void> saveReview() async {
    //==========================================================
    // VALIDATE COMMENT
    //==========================================================

    if (reviewControllerText.text.trim().isEmpty) {
      Snack_Bar.show(
        title: "Review Required",
        message: "Please write your review.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // GET CURRENT USER
    //==========================================================

    final user = userController.currentUser.value;

    if (user == null || user.id.trim().isEmpty) {
      Snack_Bar.show(
        title: "Login Required",
        message: "Please login to submit a review.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // UPDATE EXISTING REVIEW
    //==========================================================

    if (editingReview != null) {
      final bool success = await reviewController.updateReview(
        reviewId: editingReview!.id,
        rating: rating,
        comment: reviewControllerText.text.trim(),
      );

      if (!success) {
        Snack_Bar.show(
          title: "Error",
          message: reviewController.errorMessage.value,
          icon: FontAwesomeIcons.circleExclamation,
        );

        return;
      }

      Get.back();

      Snack_Bar.show(
        title: "Success",
        message: "Review updated successfully.",
        icon: FontAwesomeIcons.solidCircleCheck,
      );

      return;
    }

    //==========================================================
    // CREATE NEW REVIEW
    //==========================================================

    final bool success = await reviewController.addReview(
      userId: user.id,
      rating: rating,
      comment: reviewControllerText.text.trim(),
    );

    if (!success) {
      Snack_Bar.show(
        title: "Error",
        message: reviewController.errorMessage.value,
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    Get.back();

    Snack_Bar.show(
      title: "Success",
      message: "Review submitted successfully.",
      icon: FontAwesomeIcons.solidCircleCheck,
    );
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //========================================================
      // BOTTOM BUTTON
      //========================================================
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: AppConstants.buttonHeight,
              child: Obx(
                () => ElevatedButton(
                  onPressed: reviewController.isSaving.value
                      ? null
                      : saveReview,
                  child: reviewController.isSaving.value
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          editingReview == null
                              ? "Submit Review"
                              : "Update Review",
                          style: AppTextTheme.titleText,
                        ),
                ),
              ),
            ),

            //========================================================
            // DELETE REVIEW
            //========================================================
            if (editingReview != null) ...[
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton.icon(
                  onPressed: reviewController.isSaving.value
                      ? null
                      : deleteMyReview,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: Text(
                    "Delete Review",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),

      //========================================================
      // BODY
      //========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  //================================================
                  // APP BAR
                  //================================================

                  AppBarWidget(),

                  const SizedBox(height: 35),

                  //================================================
                  // TITLE
                  //================================================
                  Text(
                    "How was your experience?",
                    style: AppTextTheme.titleText,
                  ),

                  const SizedBox(height: 20),

                  //================================================
                  // RATING BAR
                  //================================================
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 40,
                    glow: false,

                    itemBuilder: (_, _) =>
                        const Icon(Icons.star, color: Colors.amber),

                    onRatingUpdate: (value) {
                      setState(() {
                        rating = value;
                      });
                    },
                  ),

                  const SizedBox(height: 35),

                  //================================================
                  // COMMENT TITLE
                  //================================================
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Tell us more",
                      style: AppTextTheme.textfieldtitleText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  //================================================
                  // COMMENT
                  //================================================
                  TextFormField(
                    controller: reviewControllerText,
                    maxLines: 6,

                    decoration: InputDecoration(
                      hintText: "Share your experience with Quick Bite...",

                      hintStyle: AppTextTheme.caption,

                      filled: true,

                      fillColor: Colors.white,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  //================================================
                  // INFO BOX
                  //================================================
                  Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            "Your feedback helps us improve our food and delivery service.",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBarWidget() {
    return Row(
      children: [
        Back_Button(),

        const SizedBox(width: 15),

        Text(
          editingReview == null ? "Write Review" : "Edit Review",
          style: AppTextTheme.appbarText,
        ),
      ],
    );
  }
}
