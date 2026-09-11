// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/AppReview_Model.dart';

class AppReviewService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // APP REVIEWS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get _appReviewsCollection =>
          _firestore.collection('appReviews');

  //============================================================
  // CREATE APP REVIEW
  //============================================================

  Future<void> createAppReview({
    required String userId,
    required double rating,
    required String comment,
  }) async {
    //==========================================================
    // VALIDATION
    //==========================================================

    if (userId.trim().isEmpty) {
      throw Exception(
        'User ID is required.',
      );
    }

    if (rating < 1 || rating > 5) {
      throw Exception(
        'Rating must be between 1 and 5.',
      );
    }

    if (comment.trim().isEmpty) {
      throw Exception(
        'Review comment cannot be empty.',
      );
    }

    //==========================================================
    // CHECK EXISTING REVIEW
    //==========================================================

    final existingReview =
        await _appReviewsCollection
            .where(
              'userId',
              isEqualTo: userId,
            )
            .limit(1)
            .get();

    if (existingReview.docs.isNotEmpty) {
      throw Exception(
        'You have already submitted an app review.',
      );
    }

    //==========================================================
    // CREATE DOCUMENT
    //==========================================================

    final document =
        _appReviewsCollection.doc();

    await document.set({
      'id': document.id,
      'userId': userId,
      'rating': rating,
      'comment': comment.trim(),
      'createdAt':
          FieldValue.serverTimestamp(),
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // GET ALL APP REVIEWS
  //============================================================

  Stream<List<AppReviewModel>>
      getAppReviews() {
    return _appReviewsCollection
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (document) =>
                      AppReviewModel.fromFirestore(
                    document,
                  ),
                )
                .toList();
          },
        );
  }

  //============================================================
  // GET CURRENT USER REVIEW
  //============================================================

  Future<AppReviewModel?>
      getUserAppReview(
    String userId,
  ) async {
    if (userId.trim().isEmpty) {
      return null;
    }

    final snapshot =
        await _appReviewsCollection
            .where(
              'userId',
              isEqualTo: userId,
            )
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return AppReviewModel.fromFirestore(
      snapshot.docs.first,
    );
  }

  //============================================================
  // UPDATE APP REVIEW
  //============================================================

  Future<void> updateAppReview({
    required String reviewId,
    required String userId,
    required double rating,
    required String comment,
  }) async {
    //==========================================================
    // VALIDATION
    //==========================================================

    if (reviewId.trim().isEmpty) {
      throw Exception(
        'Review ID is required.',
      );
    }

    if (userId.trim().isEmpty) {
      throw Exception(
        'User ID is required.',
      );
    }

    if (rating < 1 || rating > 5) {
      throw Exception(
        'Rating must be between 1 and 5.',
      );
    }

    if (comment.trim().isEmpty) {
      throw Exception(
        'Review comment cannot be empty.',
      );
    }

    //==========================================================
    // GET REVIEW
    //==========================================================

    final document =
        await _appReviewsCollection
            .doc(reviewId)
            .get();

    if (!document.exists) {
      throw Exception(
        'Review not found.',
      );
    }

    final data = document.data();

    if (data == null) {
      throw Exception(
        'Review data not found.',
      );
    }

    //==========================================================
    // OWNERSHIP CHECK
    //==========================================================

    if (data['userId'] != userId) {
      throw Exception(
        'You can only edit your own review.',
      );
    }

    //==========================================================
    // UPDATE
    //==========================================================

    await _appReviewsCollection
        .doc(reviewId)
        .update({
      'rating': rating,
      'comment': comment.trim(),
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // DELETE APP REVIEW
  //============================================================

  Future<void> deleteAppReview({
    required String reviewId,
    required String userId,
  }) async {
    //==========================================================
    // VALIDATION
    //==========================================================

    if (reviewId.trim().isEmpty) {
      throw Exception(
        'Review ID is required.',
      );
    }

    if (userId.trim().isEmpty) {
      throw Exception(
        'User ID is required.',
      );
    }

    //==========================================================
    // GET REVIEW
    //==========================================================

    final document =
        await _appReviewsCollection
            .doc(reviewId)
            .get();

    if (!document.exists) {
      throw Exception(
        'Review not found.',
      );
    }

    final data = document.data();

    if (data == null) {
      throw Exception(
        'Review data not found.',
      );
    }

    //==========================================================
    // OWNERSHIP CHECK
    //==========================================================

    if (data['userId'] != userId) {
      throw Exception(
        'You can only delete your own review.',
      );
    }

    //==========================================================
    // DELETE
    //==========================================================

    await _appReviewsCollection
        .doc(reviewId)
        .delete();
  }

  //============================================================
  // GET SINGLE APP REVIEW
  //============================================================

  Future<AppReviewModel?>
      getAppReview(
    String reviewId,
  ) async {
    final document =
        await _appReviewsCollection
            .doc(reviewId)
            .get();

    if (!document.exists) {
      return null;
    }

    return AppReviewModel.fromFirestore(
      document,
    );
  }
}