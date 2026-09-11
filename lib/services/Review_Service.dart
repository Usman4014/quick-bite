// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/Review_Model.dart';

class ReviewService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //============================================================
  // REVIEWS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      _firestore.collection('reviews');

  //============================================================
  // CREATE REVIEW
  //============================================================

  Future<void> createReview({
    required String userId,
    String? productId,
    String? specialDealId,
    String? orderId,
    required double rating,
    required String comment,
  }) async {
    //============================================================
    // VALIDATION
    //============================================================

    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }

    if (productId == null && specialDealId == null) {
      throw Exception('A review must belong to a product or special deal.');
    }

    if (productId != null && specialDealId != null) {
      throw Exception(
        'A review cannot belong to both a product and special deal.',
      );
    }

    if (rating < 1 || rating > 5) {
      throw Exception('Rating must be between 1 and 5.');
    }

    if (comment.trim().isEmpty) {
      throw Exception('Review comment cannot be empty.');
    }

    //============================================================
    // CHECK EXISTING PRODUCT REVIEW
    //============================================================

    if (productId != null) {
      final existingReview = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (existingReview.docs.isNotEmpty) {
        throw Exception('You have already reviewed this product.');
      }
    }

    //============================================================
    // CHECK EXISTING SPECIAL DEAL REVIEW
    //============================================================

    if (specialDealId != null) {
      final existingReview = await _reviewsCollection
          .where('userId', isEqualTo: userId)
          .where('specialDealId', isEqualTo: specialDealId)
          .limit(1)
          .get();

      if (existingReview.docs.isNotEmpty) {
        throw Exception('You have already reviewed this special deal.');
      }
    }

    //============================================================
    // CREATE DOCUMENT
    //============================================================

    final document = _reviewsCollection.doc();

    await document.set({
      'id': document.id,

      'userId': userId,

      'productId': productId,

      'specialDealId': specialDealId,

      'orderId': orderId,

      'rating': rating,

      'comment': comment.trim(),

      'createdAt': FieldValue.serverTimestamp(),

      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // PRODUCT REVIEWS
  //============================================================

  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _reviewsCollection
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((document) => ReviewModel.fromFirestore(document))
              .toList();
        });
  }

  //============================================================
  // SPECIAL DEAL REVIEWS
  //============================================================

  Stream<List<ReviewModel>> getSpecialDealReviews(String specialDealId) {
    return _reviewsCollection
        .where('specialDealId', isEqualTo: specialDealId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((document) => ReviewModel.fromFirestore(document))
              .toList();
        });
  }

  //============================================================
  // USER REVIEWS
  //============================================================

  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _reviewsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((document) => ReviewModel.fromFirestore(document))
              .toList();
        });
  }

  //============================================================
  // UPDATE REVIEW
  //============================================================

  Future<void> updateReview({
    required String reviewId,
    required double rating,
    required String comment,
  }) async {
    if (rating < 1 || rating > 5) {
      throw Exception('Rating must be between 1 and 5.');
    }

    if (comment.trim().isEmpty) {
      throw Exception('Review comment cannot be empty.');
    }

    await _reviewsCollection.doc(reviewId).update({
      'rating': rating,
      'comment': comment.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // DELETE REVIEW
  //============================================================

  Future<void> deleteReview(String reviewId) async {
    await _reviewsCollection.doc(reviewId).delete();
  }

  //============================================================
  // GET SINGLE REVIEW
  //============================================================

  Future<ReviewModel?> getReview(String reviewId) async {
    final document = await _reviewsCollection.doc(reviewId).get();

    if (!document.exists) {
      return null;
    }

    return ReviewModel.fromFirestore(document);
  }
}
