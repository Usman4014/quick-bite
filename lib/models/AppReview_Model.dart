// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AppReviewModel {
  //============================================================
  // BASIC INFORMATION
  //============================================================

  final String id;

  /// Firebase UID of the customer
  final String userId;

  //============================================================
  // REVIEW
  //============================================================

  final double rating;

  final String comment;

  //============================================================
  // DATE
  //============================================================

  final DateTime createdAt;

  //============================================================
  // CONSTRUCTOR
  //============================================================

  const AppReviewModel({
    required this.id,
    required this.userId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  //============================================================
  // FROM FIRESTORE
  //============================================================

  factory AppReviewModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw Exception(
        'App review data is empty.',
      );
    }

    final Timestamp? createdAtTimestamp =
        data['createdAt'] as Timestamp?;

    return AppReviewModel(
      id: data['id'] ?? document.id,

      userId:
          data['userId'] ?? '',

      rating:
          (data['rating'] as num?)
                  ?.toDouble() ??
              0.0,

      comment:
          data['comment'] ?? '',

      createdAt:
          createdAtTimestamp?.toDate() ??
              DateTime.now(),
    );
  }

  //============================================================
  // TO FIRESTORE
  //============================================================

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'createdAt':
          Timestamp.fromDate(createdAt),
    };
  }
}