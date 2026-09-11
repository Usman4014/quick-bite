// ignore_for_file: file_names

import 'dart:async';

import 'package:get/get.dart';
import 'package:quick_bite/models/AppReview_Model.dart';
import 'package:quick_bite/models/User_Model.dart';
import 'package:quick_bite/services/AppReview_Service.dart';
import 'package:quick_bite/services/User_Service.dart';

class AppReviewController extends GetxController {
  //============================================================
  // SERVICES
  //============================================================

  final AppReviewService _appReviewService = AppReviewService();

  final UserService _userService = UserService();

  //============================================================
  // APP REVIEWS
  //============================================================

  final RxList<AppReviewModel> appReviews = <AppReviewModel>[].obs;

  //============================================================
  // REVIEW USERS CACHE
  //============================================================

  final RxMap<String, UserModel> reviewUsers = <String, UserModel>{}.obs;

  //============================================================
  // CURRENT USER REVIEW
  //============================================================

  final Rxn<AppReviewModel> myReview = Rxn<AppReviewModel>();

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = false.obs;

  final RxBool isSaving = false.obs;

  //============================================================
  // ERROR
  //============================================================

  final RxString errorMessage = ''.obs;

  //============================================================
  // SUBSCRIPTION
  //============================================================

  StreamSubscription<List<AppReviewModel>>? _reviewSubscription;

  //============================================================
  // LOAD REVIEW USER
  //============================================================

  Future<UserModel?> getReviewUser(String userId) async {
    if (userId.trim().isEmpty) {
      return null;
    }

    //==========================================================
    // CHECK CACHE
    //==========================================================

    if (reviewUsers.containsKey(userId)) {
      return reviewUsers[userId];
    }

    //==========================================================
    // LOAD FROM FIRESTORE
    //==========================================================

    try {
      final UserModel? user = await _userService.getUser(userId);

      if (user != null) {
        reviewUsers[userId] = user;
      }

      return user;
    } catch (_) {
      return null;
    }
  }

  //============================================================
  // LOAD ALL REVIEW USERS
  //============================================================

  Future<void> loadReviewUsers(List<AppReviewModel> reviews) async {
    final Set<String> userIds = reviews
        .map((review) => review.userId)
        .where((id) => id.isNotEmpty)
        .toSet();

    for (final userId in userIds) {
      await getReviewUser(userId);
    }
  }

  //============================================================
  // LOAD ALL APP REVIEWS
  //============================================================

  void loadAppReviews() {
    _cancelSubscription();

    isLoading.value = true;
    errorMessage.value = '';

    _reviewSubscription = _appReviewService.getAppReviews().listen(
      (data) async {
        //======================================================
        // UPDATE REVIEWS
        //======================================================

        appReviews.assignAll(data);

        //======================================================
        // LOAD ALL REVIEW USERS
        //======================================================

        await loadReviewUsers(data);

        //======================================================
        // MAKE SURE MY REVIEW IS UP TO DATE
        //======================================================

        final currentReview = myReview.value;

        if (currentReview != null) {
          final updatedMyReview = data.cast<AppReviewModel?>().firstWhere(
            (review) => review!.id == currentReview.id,
            orElse: () => null,
          );

          myReview.value = updatedMyReview;

          if (updatedMyReview != null) {
            await getReviewUser(updatedMyReview.userId);
          }
        }

        isLoading.value = false;
        errorMessage.value = '';
      },
      onError: (error) {
        isLoading.value = false;

        errorMessage.value = error.toString();
      },
    );
  }

  //============================================================
  // LOAD CURRENT USER REVIEW
  //============================================================

  Future<void> loadMyReview(String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final AppReviewModel? review = await _appReviewService.getUserAppReview(
        userId,
      );

      myReview.value = review;

      //========================================================
      // LOAD CORRECT USER PROFILE
      //========================================================

      if (review != null) {
        await getReviewUser(review.userId);
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  //============================================================
  // ADD APP REVIEW
  //============================================================

  Future<bool> addReview({
    required String userId,
    required double rating,
    required String comment,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      //========================================================
      // CREATE REVIEW
      //========================================================

      await _appReviewService.createAppReview(
        userId: userId,
        rating: rating,
        comment: comment,
      );

      //========================================================
      // GET NEWLY CREATED REVIEW
      //========================================================

      final AppReviewModel? newReview = await _appReviewService
          .getUserAppReview(userId);

      if (newReview == null) {
        throw Exception('Review was created but could not be loaded.');
      }

      //========================================================
      // UPDATE MY REVIEW
      //========================================================

      myReview.value = newReview;

      //========================================================
      // IMPORTANT:
      // LOAD THE CORRECT USER PROFILE
      //========================================================

      // Remove any old/stale cached profile.
      reviewUsers.remove(newReview.userId);

      // Fetch the latest profile from Firestore.
      final UserModel? user = await getReviewUser(newReview.userId);

      if (user == null) {
        throw Exception('Could not load reviewer profile.');
      }

      //========================================================
      // UPDATE PUBLIC REVIEW LIST
      //========================================================

      final int existingIndex = appReviews.indexWhere(
        (review) => review.id == newReview.id,
      );

      if (existingIndex == -1) {
        appReviews.insert(0, newReview);
      } else {
        appReviews[existingIndex] = newReview;
      }

      //========================================================
      // FORCE UI UPDATE
      //========================================================

      appReviews.refresh();
      reviewUsers.refresh();

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  //============================================================
  // UPDATE APP REVIEW
  //============================================================

  Future<bool> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      //========================================================
      // CURRENT REVIEW
      //========================================================

      final currentReview = myReview.value;

      if (currentReview == null || currentReview.id != reviewId) {
        throw Exception('Your review could not be found.');
      }

      //========================================================
      // UPDATE FIRESTORE
      //========================================================

      await _appReviewService.updateAppReview(
        reviewId: reviewId,
        userId: currentReview.userId,
        rating: rating,
        comment: comment,
      );

      //========================================================
      // CREATE UPDATED LOCAL REVIEW
      //========================================================

      final updatedReview = AppReviewModel(
        id: currentReview.id,
        userId: currentReview.userId,
        rating: rating,
        comment: comment.trim(),
        createdAt: currentReview.createdAt,
      );

      //========================================================
      // UPDATE MY REVIEW
      //========================================================

      myReview.value = updatedReview;

      //========================================================
      // UPDATE REVIEW LIST
      //========================================================

      final index = appReviews.indexWhere((review) => review.id == reviewId);

      if (index != -1) {
        appReviews[index] = updatedReview;
      }

      //========================================================
      // MAKE SURE USER PROFILE EXISTS
      //========================================================

      await getReviewUser(updatedReview.userId);

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  //============================================================
  // DELETE APP REVIEW
  //============================================================

  Future<bool> deleteReview(String reviewId) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      //========================================================
      // CURRENT REVIEW
      //========================================================

      final currentReview = myReview.value;

      if (currentReview == null || currentReview.id != reviewId) {
        throw Exception('Your review could not be found.');
      }

      //========================================================
      // DELETE FROM FIRESTORE
      //========================================================

      await _appReviewService.deleteAppReview(
        reviewId: reviewId,
        userId: currentReview.userId,
      );

      //========================================================
      // REMOVE FROM LOCAL LIST
      //========================================================

      appReviews.removeWhere((review) => review.id == reviewId);

      //========================================================
      // CLEAR MY REVIEW
      //========================================================

      myReview.value = null;

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  //============================================================
  // GET REVIEW USER
  //============================================================

  UserModel? getCachedReviewUser(String userId) {
    return reviewUsers[userId];
  }

  //============================================================
  // AVERAGE RATING
  //============================================================

  double get averageRating {
    if (appReviews.isEmpty) {
      return 0.0;
    }

    final double total = appReviews.fold(
      0.0,
      (sum, review) => sum + review.rating,
    );

    return total / appReviews.length;
  }

  //============================================================
  // TOTAL REVIEWS
  //============================================================

  int get totalReviews {
    return appReviews.length;
  }

  //============================================================
  // RATING COUNT
  //============================================================

  int ratingCount(int rating) {
    return appReviews.where((review) => review.rating.round() == rating).length;
  }

  //============================================================
  // RATING PERCENTAGE
  //============================================================

  double ratingPercentage(int rating) {
    if (appReviews.isEmpty) {
      return 0.0;
    }

    return ratingCount(rating) / appReviews.length;
  }

  //============================================================
  // 5 STAR REVIEWS
  //============================================================

  int get fiveStarReviews => ratingCount(5);

  //============================================================
  // 4 STAR REVIEWS
  //============================================================

  int get fourStarReviews => ratingCount(4);

  //============================================================
  // 3 STAR REVIEWS
  //============================================================

  int get threeStarReviews => ratingCount(3);

  //============================================================
  // 2 STAR REVIEWS
  //============================================================

  int get twoStarReviews => ratingCount(2);

  //============================================================
  // 1 STAR REVIEWS
  //============================================================

  int get oneStarReviews => ratingCount(1);

  //============================================================
  // CHECK CURRENT USER REVIEW
  //============================================================

  bool get hasMyReview {
    return myReview.value != null;
  }

  //============================================================
  // CLEAR REVIEWS
  //============================================================

  void clearReviews() {
    _cancelSubscription();

    appReviews.clear();

    reviewUsers.clear();

    myReview.value = null;

    isLoading.value = false;

    errorMessage.value = '';
  }

  //============================================================
  // CLEAR ERROR
  //============================================================

  void clearError() {
    errorMessage.value = '';
  }

  //============================================================
  // CANCEL SUBSCRIPTION
  //============================================================

  void _cancelSubscription() {
    _reviewSubscription?.cancel();

    _reviewSubscription = null;
  }

  //============================================================
  // CLOSE
  //============================================================

  @override
  void onClose() {
    _cancelSubscription();

    super.onClose();
  }
}
