// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;

  /// Firebase UID of the customer
  final String userId;

  /// Product document ID
  final String? productId;

  /// Special deal document ID
  final String? specialDealId;

  /// Order document ID
  final String? orderId;

  final double rating;

  final String comment;

  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    this.productId,
    this.specialDealId,
    this.orderId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });


  factory ReviewModel.fromFirestore(
  DocumentSnapshot<Map<String, dynamic>> document,
) {
  final data = document.data() ?? {};

  return ReviewModel(
    id: document.id,

    userId:
        data['userId']?.toString() ?? '',

    productId:
        data['productId']?.toString(),

    specialDealId:
        data['specialDealId']?.toString(),

    orderId:
        data['orderId']?.toString(),

    rating:
        (data['rating'] as num?)
                ?.toDouble() ??
            0.0,

    comment:
        data['comment']?.toString() ?? '',

    createdAt:
        _dateFromFirestore(
      data['createdAt'],
    ),
  );
}

static DateTime _dateFromFirestore(
  dynamic value,
) {
  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  return DateTime.now();
}
}