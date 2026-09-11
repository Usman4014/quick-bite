// ignore_for_file: file_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:quick_bite/models/Review_Model.dart';
import 'package:quick_bite/models/User_Model.dart';
import 'package:quick_bite/services/Review_Service.dart';
import 'package:quick_bite/services/User_Service.dart';

class ReviewController extends GetxController {
  //============================================================
  // SERVICES
  //============================================================

  final ReviewService _reviewService = ReviewService();

  final UserService _userService = UserService();

  //============================================================
  // REVIEW USERS CACHE
  //============================================================

  /// Stores reviewer profiles by Firebase UID.
  ///
  /// This prevents repeatedly downloading the same user profile
  /// when multiple reviews belong to the same user.
  final RxMap<String, UserModel> reviewUsers = <String, UserModel>{}.obs;

  //============================================================
  // IN-FLIGHT USER REQUESTS
  //============================================================

  /// Prevents duplicate Firestore requests when the same user
  /// appears in multiple reviews before the first request finishes.
  final Map<String, Future<UserModel?>> _userRequests = {};

  //============================================================
  // PRODUCT REVIEWS
  //============================================================

  /// Product ID -> Reviews
  final RxMap<String, List<ReviewModel>> productReviews =
      <String, List<ReviewModel>>{}.obs;

  //============================================================
  // SPECIAL DEAL REVIEWS
  //============================================================

  /// Special Deal ID -> Reviews
  final RxMap<String, List<ReviewModel>> specialDealReviews =
      <String, List<ReviewModel>>{}.obs;

  //============================================================
  // MY REVIEWS
  //============================================================

  final RxList<ReviewModel> myReviews = <ReviewModel>[].obs;

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
  // PRODUCT SUBSCRIPTIONS
  //============================================================

  final Map<String, StreamSubscription<List<ReviewModel>>>
  _productSubscriptions = {};

  //============================================================
  // SPECIAL DEAL SUBSCRIPTIONS
  //============================================================

  final Map<String, StreamSubscription<List<ReviewModel>>>
  _specialDealSubscriptions = {};

  //============================================================
  // MY REVIEWS SUBSCRIPTION
  //============================================================

  StreamSubscription<List<ReviewModel>>? _myReviewsSubscription;

  //============================================================
  // LOADING STREAM COUNT
  //============================================================

  int _activeLoadingStreams = 0;

  //============================================================
  // ON INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    loadMyReviews();
  }

  //============================================================
  // LOADING HELPERS
  //============================================================

  void _startLoading() {
    _activeLoadingStreams++;

    if (!isLoading.value) {
      isLoading.value = true;
    }
  }

  void _stopLoading() {
    if (_activeLoadingStreams > 0) {
      _activeLoadingStreams--;
    }

    if (_activeLoadingStreams == 0) {
      isLoading.value = false;
    }
  }

  //============================================================
  // LOAD REVIEW USER
  //============================================================

  Future<UserModel?> getReviewUser(String userId) {
    final String normalizedId = userId.trim();

    //==========================================================
    // INVALID USER ID
    //==========================================================

    if (normalizedId.isEmpty) {
      return Future.value(null);
    }

    //==========================================================
    // ALREADY CACHED
    //==========================================================

    final cachedUser = reviewUsers[normalizedId];

    if (cachedUser != null) {
      return Future.value(cachedUser);
    }

    //==========================================================
    // REQUEST ALREADY IN PROGRESS
    //==========================================================

    final existingRequest = _userRequests[normalizedId];

    if (existingRequest != null) {
      return existingRequest;
    }

    //==========================================================
    // CREATE SINGLE USER REQUEST
    //==========================================================

    final Future<UserModel?> request = _loadReviewUser(normalizedId);

    _userRequests[normalizedId] = request;

    return request;
  }

  //============================================================
  // LOAD USER INTERNALLY
  //============================================================

  Future<UserModel?> _loadReviewUser(String userId) async {
    try {
      final UserModel? user = await _userService.getUser(userId);

      if (user != null) {
        reviewUsers[userId] = user;
      }

      return user;
    } catch (_) {
      return null;
    } finally {
      _userRequests.remove(userId);
    }
  }

  //============================================================
  // LOAD REVIEW USERS
  //============================================================

  /// Loads only unique reviewer IDs that are not already cached.
  void _loadReviewUsers(Iterable<ReviewModel> reviews) {
    final Set<String> userIds = <String>{};

    for (final ReviewModel review in reviews) {
      final String userId = review.userId.trim();

      if (userId.isEmpty) {
        continue;
      }

      if (reviewUsers.containsKey(userId)) {
        continue;
      }

      userIds.add(userId);
    }

    for (final String userId in userIds) {
      unawaited(getReviewUser(userId));
    }
  }

  //============================================================
  // LOAD PRODUCT REVIEWS
  //============================================================

  void loadProductReviews(String productId) {
    final String normalizedId = productId.trim();

    if (normalizedId.isEmpty) {
      return;
    }

    //==========================================================
    // ALREADY LISTENING
    //==========================================================

    if (_productSubscriptions.containsKey(normalizedId)) {
      return;
    }

    _startLoading();

    errorMessage.value = '';

    //==========================================================
    // FIRESTORE STREAM
    //==========================================================

    late final StreamSubscription<List<ReviewModel>> subscription;

    subscription = _reviewService
        .getProductReviews(normalizedId)
        .listen(
          (List<ReviewModel> data) {
            productReviews[normalizedId] = List<ReviewModel>.unmodifiable(data);

            _loadReviewUsers(data);

            _stopLoading();

            errorMessage.value = '';
          },
          onError: (Object error) {
            _stopLoading();

            errorMessage.value = error.toString();

            _productSubscriptions.remove(normalizedId);

            unawaited(subscription.cancel());

            debugPrint('PRODUCT REVIEW ERROR: $error');
          },
        );

    _productSubscriptions[normalizedId] = subscription;
  }

  //============================================================
  // GET PRODUCT REVIEWS
  //============================================================

  List<ReviewModel> getReviewsByProduct(String productId) {
    return productReviews[productId] ?? const <ReviewModel>[];
  }

  //============================================================
  // LOAD SPECIAL DEAL REVIEWS
  //============================================================

  void loadSpecialDealReviews(String specialDealId) {
    final String normalizedId = specialDealId.trim();

    if (normalizedId.isEmpty) {
      return;
    }

    //==========================================================
    // AUTHENTICATION
    //==========================================================

    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      errorMessage.value = 'User is not authenticated.';

      return;
    }

    //==========================================================
    // ALREADY LISTENING
    //==========================================================

    if (_specialDealSubscriptions.containsKey(normalizedId)) {
      return;
    }

    _startLoading();

    errorMessage.value = '';

    //==========================================================
    // FIRESTORE STREAM
    //==========================================================

    late final StreamSubscription<List<ReviewModel>> subscription;

    subscription = _reviewService
        .getSpecialDealReviews(normalizedId)
        .listen(
          (List<ReviewModel> data) {
            specialDealReviews[normalizedId] = List<ReviewModel>.unmodifiable(
              data,
            );

            _loadReviewUsers(data);

            _stopLoading();

            errorMessage.value = '';
          },
          onError: (Object error) {
            _stopLoading();

            errorMessage.value = error.toString();

            _specialDealSubscriptions.remove(normalizedId);

            unawaited(subscription.cancel());

            debugPrint('SPECIAL DEAL REVIEW ERROR: $error');
          },
        );

    _specialDealSubscriptions[normalizedId] = subscription;
  }

  //============================================================
  // GET SPECIAL DEAL REVIEWS
  //============================================================

  List<ReviewModel> getReviewsByDeal(String specialDealId) {
    return specialDealReviews[specialDealId] ?? const <ReviewModel>[];
  }

  //============================================================
  // LOAD MY REVIEWS
  //============================================================

  void loadMyReviews() {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    //==========================================================
    // NOT AUTHENTICATED
    //==========================================================

    if (userId == null || userId.trim().isEmpty) {
      myReviews.clear();

      return;
    }

    //==========================================================
    // CANCEL OLD SUBSCRIPTION
    //==========================================================

    unawaited(_myReviewsSubscription?.cancel() ?? Future<void>.value());

    _startLoading();

    errorMessage.value = '';

    //==========================================================
    // FIRESTORE STREAM
    //==========================================================

    _myReviewsSubscription = _reviewService
        .getUserReviews(userId)
        .listen(
          (List<ReviewModel> data) {
            myReviews.assignAll(data);

            _loadReviewUsers(data);

            _stopLoading();

            errorMessage.value = '';
          },
          onError: (Object error) {
            _stopLoading();

            errorMessage.value = error.toString();

            debugPrint('MY REVIEWS ERROR: $error');
          },
        );
  }

  //============================================================
  // MY TOTAL REVIEWS
  //============================================================

  int get myTotalReviews {
    return myReviews.length;
  }

  //============================================================
  // ADD REVIEW
  //============================================================

  Future<bool> addReview({
    required String userId,
    String? productId,
    String? specialDealId,
    String? orderId,
    required double rating,
    required String comment,
  }) async {
    try {
      isSaving.value = true;

      errorMessage.value = '';

      //========================================================
      // CREATE REVIEW
      //========================================================

      await _reviewService.createReview(
        userId: userId,
        productId: productId,
        specialDealId: specialDealId,
        orderId: orderId,
        rating: rating,
        comment: comment,
      );

      //========================================================
      // IMPORTANT
      //========================================================
      //
      // DO NOT clear/restart the Firestore listener here.
      //
      // The existing listener automatically receives the
      // newly created review.
      //
      // This avoids an unnecessary listener recreation and
      // another initial Firestore read.
      //========================================================

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  //============================================================
  // UPDATE REVIEW
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
      // UPDATE FIRESTORE
      //========================================================

      await _reviewService.updateReview(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
      );

      //========================================================
      // IMPORTANT
      //========================================================
      //
      // No getReview() call.
      // No listener restart.
      //
      // The active Firestore listener will receive the update.
      //
      // This removes one extra Firestore read and avoids
      // unnecessary stream recreation.
      //========================================================

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  //============================================================
  // DELETE REVIEW
  //============================================================

  Future<bool> deleteReview(String reviewId) async {
    try {
      isSaving.value = true;

      errorMessage.value = '';

      //========================================================
      // FIND LOCAL REVIEW FIRST
      //========================================================

      ReviewModel? review;

      // Product reviews
      for (final List<ReviewModel> reviews in productReviews.values) {
        for (final ReviewModel item in reviews) {
          if (item.id == reviewId) {
            review = item;
            break;
          }
        }

        if (review != null) {
          break;
        }
      }

      // Special deal reviews
      if (review == null) {
        for (final List<ReviewModel> reviews in specialDealReviews.values) {
          for (final ReviewModel item in reviews) {
            if (item.id == reviewId) {
              review = item;
              break;
            }
          }

          if (review != null) {
            break;
          }
        }
      }

      // My reviews
      review ??= _findMyReview(reviewId);

      //========================================================
      // DELETE FROM FIRESTORE
      //========================================================

      await _reviewService.deleteReview(reviewId);

      //========================================================
      // OPTIMISTIC LOCAL UPDATE
      //========================================================

      if (review?.productId != null && review!.productId!.isNotEmpty) {
        final String productId = review.productId!;

        final List<ReviewModel>? reviews = productReviews[productId];

        if (reviews != null) {
          productReviews[productId] = List<ReviewModel>.unmodifiable(
            reviews.where((item) => item.id != reviewId),
          );
        }
      }

      //========================================================
      // REMOVE FROM SPECIAL DEAL CACHE
      //========================================================

      if (review?.specialDealId != null && review!.specialDealId!.isNotEmpty) {
        final String dealId = review.specialDealId!;

        final List<ReviewModel>? reviews = specialDealReviews[dealId];

        if (reviews != null) {
          specialDealReviews[dealId] = List<ReviewModel>.unmodifiable(
            reviews.where((item) => item.id != reviewId),
          );
        }
      }

      //========================================================
      // REMOVE FROM MY REVIEWS
      //========================================================

      myReviews.removeWhere((item) => item.id == reviewId);

      return true;
    } catch (e) {
      errorMessage.value = e.toString();

      return false;
    } finally {
      isSaving.value = false;
    }
  }

  //============================================================
  // FIND MY REVIEW
  //============================================================

  ReviewModel? _findMyReview(String reviewId) {
    for (final ReviewModel review in myReviews) {
      if (review.id == reviewId) {
        return review;
      }
    }

    return null;
  }

  //============================================================
  // GET USER REVIEW FOR PRODUCT
  //============================================================

  ReviewModel? getUserProductReview(String userId, String productId) {
    final List<ReviewModel> reviews = getReviewsByProduct(productId);

    for (final ReviewModel review in reviews) {
      if (review.userId == userId && review.productId == productId) {
        return review;
      }
    }

    return null;
  }

  //============================================================
  // GET USER REVIEW FOR SPECIAL DEAL
  //============================================================

  ReviewModel? getUserSpecialDealReview(String userId, String specialDealId) {
    final List<ReviewModel> reviews = getReviewsByDeal(specialDealId);

    for (final ReviewModel review in reviews) {
      if (review.userId == userId && review.specialDealId == specialDealId) {
        return review;
      }
    }

    return null;
  }

  //============================================================
  // AVERAGE RATING FOR PRODUCT
  //============================================================

  double getAverageRatingForProduct(String productId) {
    final List<ReviewModel> reviews = getReviewsByProduct(productId);

    if (reviews.isEmpty) {
      return 0.0;
    }

    double total = 0.0;

    for (final ReviewModel review in reviews) {
      total += review.rating;
    }

    return total / reviews.length;
  }

  //============================================================
  // TOTAL REVIEWS FOR PRODUCT
  //============================================================

  int getTotalReviewsForProduct(String productId) {
    return getReviewsByProduct(productId).length;
  }

  //============================================================
  // AVERAGE RATING FOR SPECIAL DEAL
  //============================================================

  double getAverageRatingForDeal(String dealId) {
    final List<ReviewModel> reviews = getReviewsByDeal(dealId);

    if (reviews.isEmpty) {
      return 0.0;
    }

    double total = 0.0;

    for (final ReviewModel review in reviews) {
      total += review.rating;
    }

    return total / reviews.length;
  }

  //============================================================
  // TOTAL REVIEWS FOR SPECIAL DEAL
  //============================================================

  int getTotalReviewsForDeal(String dealId) {
    return getReviewsByDeal(dealId).length;
  }

  //============================================================
  // RATING COUNT FOR PRODUCT
  //============================================================

  int ratingCountForProduct(String productId, int rating) {
    int count = 0;

    for (final ReviewModel review in getReviewsByProduct(productId)) {
      if (review.rating.round() == rating) {
        count++;
      }
    }

    return count;
  }

  //============================================================
  // RATING PERCENTAGE FOR PRODUCT
  //============================================================

  double ratingPercentageForProduct(String productId, int rating) {
    final List<ReviewModel> reviews = getReviewsByProduct(productId);

    if (reviews.isEmpty) {
      return 0.0;
    }

    return ratingCountForProduct(productId, rating) / reviews.length;
  }

  //============================================================
  // RATING COUNT FOR SPECIAL DEAL
  //============================================================

  int ratingCountForDeal(String dealId, int rating) {
    int count = 0;

    for (final ReviewModel review in getReviewsByDeal(dealId)) {
      if (review.rating.round() == rating) {
        count++;
      }
    }

    return count;
  }

  //============================================================
  // RATING PERCENTAGE FOR SPECIAL DEAL
  //============================================================

  double ratingPercentageForDeal(String dealId, int rating) {
    final List<ReviewModel> reviews = getReviewsByDeal(dealId);

    if (reviews.isEmpty) {
      return 0.0;
    }

    return ratingCountForDeal(dealId, rating) / reviews.length;
  }

  //============================================================
  // CLEAR PRODUCT REVIEWS
  //============================================================

  Future<void> clearProductReviews(String productId) async {
    final String normalizedId = productId.trim();

    final subscription = _productSubscriptions.remove(normalizedId);

    await subscription?.cancel();

    productReviews.remove(normalizedId);
  }

  //============================================================
  // CLEAR SPECIAL DEAL REVIEWS
  //============================================================

  Future<void> clearSpecialDealReviews(String specialDealId) async {
    final String normalizedId = specialDealId.trim();

    final subscription = _specialDealSubscriptions.remove(normalizedId);

    await subscription?.cancel();

    specialDealReviews.remove(normalizedId);
  }

  //============================================================
  // CLEAR ERROR
  //============================================================

  void clearError() {
    errorMessage.value = '';
  }

  //============================================================
  // CLOSE
  //============================================================

  @override
  void onClose() {
    //==========================================================
    // CANCEL PRODUCT STREAMS
    //==========================================================

    for (final StreamSubscription<List<ReviewModel>> subscription
        in _productSubscriptions.values) {
      unawaited(subscription.cancel());
    }

    _productSubscriptions.clear();

    //==========================================================
    // CANCEL SPECIAL DEAL STREAMS
    //==========================================================

    for (final StreamSubscription<List<ReviewModel>> subscription
        in _specialDealSubscriptions.values) {
      unawaited(subscription.cancel());
    }

    _specialDealSubscriptions.clear();

    //==========================================================
    // CANCEL MY REVIEWS STREAM
    //==========================================================

    unawaited(_myReviewsSubscription?.cancel() ?? Future<void>.value());

    _myReviewsSubscription = null;

    //==========================================================
    // CLEAR IN-FLIGHT REQUEST REFERENCES
    //==========================================================

    _userRequests.clear();

    super.onClose();
  }
}
