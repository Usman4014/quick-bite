// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quick_bite/models/Special_Deals_Model.dart';

class SpecialDealService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // SPECIAL DEALS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get _specialDealsCollection =>
          _firestore.collection('specialDeals');

  //============================================================
  // GET ACTIVE SPECIAL DEALS
  //============================================================

  Future<List<SpecialDealsModel>> getActiveSpecialDeals() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _specialDealsCollection
            .where(
              'isActive',
              isEqualTo: true,
            )
            .get();

    return snapshot.docs
        .map(
          (doc) => _mapSpecialDeal(
            doc.id,
            doc.data(),
          ),
        )
        .toList(growable: false);
  }

  //============================================================
  // MAP SPECIAL DEAL
  //============================================================

  SpecialDealsModel _mapSpecialDeal(
    String id,
    Map<String, dynamic> data,
  ) {
    //==========================================================
    // ITEMS
    //==========================================================

    final List<dynamic> itemsData =
        data['items'] as List<dynamic>? ?? const [];

    final List<String> items = itemsData
        .map(
          (item) => item.toString(),
        )
        .toList(growable: false);

    //==========================================================
    // SPECIAL DEAL
    //==========================================================

    return SpecialDealsModel(
      id: id,

      title:
          data['title']?.toString() ?? '',

      description:
          data['description']?.toString() ?? '',

      bannerImage:
          data['bannerImage']?.toString() ?? '',

      squareImage:
          data['squareImage']?.toString() ?? '',

      items: items,

      originalPrice:
          (data['originalPrice'] as num?)
                  ?.toDouble() ??
              0.0,

      dealPrice:
          (data['dealPrice'] as num?)
                  ?.toDouble() ??
              0.0,

      discount:
          data['discount']?.toString() ?? '',

      specialNote:
          data['specialNote']?.toString() ?? '',

      isChefSpecial:
          data['isChefSpecial'] as bool? ??
              false,

      isFeatured:
          data['isFeatured'] as bool? ??
              false,

      isActive:
          data['isActive'] as bool? ??
              true,

      totalOrders:
          (data['totalOrders'] as num?)
                  ?.toInt() ??
              0,
    );
  }
}