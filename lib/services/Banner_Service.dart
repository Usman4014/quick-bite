// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/Banner_Model.dart';

class BannerService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //============================================================
  // BANNERS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _bannersCollection =>
      _firestore.collection('banners');

  //============================================================
  // GET ACTIVE BANNERS
  //============================================================

  Stream<List<BannerModel>> getBannersStream() {
    return _bannersCollection
        .where(
          'isActive',
          isEqualTo: true,
        )
        .orderBy(
          'displayOrder',
          descending: false,
        )
        .snapshots()
        .map(_mapBanners);
  }

  //============================================================
  // MAP BANNERS
  //============================================================

  List<BannerModel> _mapBanners(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs
        .map(
          (document) => BannerModel.fromFirestore(document),
        )
        .where(
          (banner) => banner.image.isNotEmpty,
        )
        .toList(growable: false);
  }
}