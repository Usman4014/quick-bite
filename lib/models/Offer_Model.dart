// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/enums/Offer_Discount_Type.dart';
import 'package:quick_bite/enums/Offer_Target.dart';

class OfferModel {
  //============================================================
  // BASIC INFORMATION
  //============================================================

  final String id;

  final String title;

  final String description;

  //============================================================
  // IMAGES
  //============================================================

  final String bannerImage;

  final String squareImage;

  //============================================================
  // OFFER SETTINGS
  //============================================================

  final bool isFeatured;

  final OfferTarget target;

  /// The ONE category this offer belongs to.
  ///
  /// One category can have multiple offers.
  final String? categoryId;

  //============================================================
  // DISCOUNT
  //============================================================

  final OfferDiscountType discountType;

  final double discountValue;

  final double minimumOrderAmount;

  //============================================================
  // DATES
  //============================================================

  final DateTime startDate;

  final DateTime endDate;

  //============================================================
  // TERMS
  //============================================================

  final List<String> terms;

  //============================================================
  // STATUS
  //============================================================

  final bool isActive;

  //============================================================
  // CONSTRUCTOR
  //============================================================

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.squareImage,
    this.isFeatured = false,
    required this.target,
    this.categoryId,
    required this.discountType,
    required this.discountValue,
    required this.minimumOrderAmount,
    required this.startDate,
    required this.endDate,
    required this.terms,
    this.isActive = true,
  });

  //============================================================
  // FROM FIRESTORE
  //============================================================

  factory OfferModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    //==========================================================
    // CATEGORY ID
    //==========================================================
    //
    // New:
    // categoryId
    //
    // Old:
    // categoryIds
    //
    // Support both during migration.
    //==========================================================

    String? categoryId;

    if (data['categoryId'] != null) {
      final value =
          data['categoryId'].toString().trim();

      if (value.isNotEmpty) {
        categoryId = value;
      }
    } else if (data['categoryIds'] is List) {
      final List<dynamic> oldCategoryIds =
          data['categoryIds'] as List<dynamic>;

      if (oldCategoryIds.isNotEmpty) {
        categoryId =
            oldCategoryIds.first.toString().trim();
      }
    }

    return OfferModel(
      id: document.id,

      title:
          data['title']?.toString() ?? '',

      description:
          data['description']?.toString() ?? '',

      bannerImage:
          data['bannerImage']?.toString() ?? '',

      squareImage:
          data['squareImage']?.toString() ?? '',

      isFeatured:
          data['isFeatured'] as bool? ?? false,

      target:
          _targetFromString(
        data['target'],
      ),

      categoryId: categoryId,

      discountType:
          _discountTypeFromString(
        data['discountType'],
      ),

      discountValue:
          (data['discountValue'] as num?)
                  ?.toDouble() ??
              0.0,

      minimumOrderAmount:
          (data['minimumOrderAmount'] as num?)
                  ?.toDouble() ??
              0.0,

      startDate:
          _dateFromFirestore(
        data['startDate'],
      ),

      endDate:
          _dateFromFirestore(
        data['endDate'],
      ),

      terms:
          List<String>.from(
        data['terms'] ?? const [],
      ),

      isActive:
          data['isActive'] as bool? ?? true,
    );
  }

  //============================================================
  // TARGET CONVERTER
  //============================================================

  static OfferTarget _targetFromString(
    dynamic value,
  ) {
    final String target =
        value?.toString() ?? '';

    return OfferTarget.values.firstWhere(
      (item) => item.name == target,
      orElse: () =>
          OfferTarget.categories,
    );
  }

  //============================================================
  // DISCOUNT TYPE CONVERTER
  //============================================================

  static OfferDiscountType
      _discountTypeFromString(
    dynamic value,
  ) {
    final String type =
        value?.toString() ?? '';

    return OfferDiscountType.values.firstWhere(
      (item) => item.name == type,
      orElse: () =>
          OfferDiscountType.percentage,
    );
  }

  //============================================================
  // DATE CONVERTER
  //============================================================

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