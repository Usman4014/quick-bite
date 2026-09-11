// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/PromoCode_Model.dart';

class PromoCodeService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // PROMO CODES COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get _promoCodesCollection =>
          _firestore.collection('promoCodes');

  //============================================================
  // GET ACTIVE PROMO CODES
  //============================================================

  Stream<List<PromoCodeModel>>
      getPromoCodesStream() {
    return _promoCodesCollection
        .where(
          'isActive',
          isEqualTo: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        final data = document.data();

        return PromoCodeModel(
          id: document.id,

          code:
              data['code']?.toString() ?? '',

          title:
              data['title']?.toString() ?? '',

          description:
              data['description']?.toString() ?? '',

          discountPercentage:
              data['discountPercentage'] != null
                  ? (data['discountPercentage'] as num)
                      .toDouble()
                  : null,

          discountAmount:
              data['discountAmount'] != null
                  ? (data['discountAmount'] as num)
                      .toDouble()
                  : null,

          minimumOrderAmount:
              data['minimumOrderAmount'] != null
                  ? (data['minimumOrderAmount'] as num)
                      .toDouble()
                  : 0.0,

          firstOrderOnly:
              data['firstOrderOnly'] ?? false,

          isActive:
              data['isActive'] ?? false,

          startDate:
              _parseDate(data['startDate']),

          endDate:
              _parseDate(data['endDate']),
        );
      }).toList();
    });
  }

  //============================================================
  // DATE PARSER
  //============================================================

  DateTime _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ??
          DateTime.now();
    }

    return DateTime.now();
  }
}