// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/fixed_asset_model.dart';

class FixedAssetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection('fixedAssets');
  }

  //============================================================
  // GET ALL ACTIVE FIXED ASSETS
  //============================================================

  Stream<List<FixedAssetModel>> listenToAssets() {
    return _collection
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (document) => FixedAssetModel.fromFirestore(
              document.id,
              document.data(),
            ),
          )
          .where((asset) => asset.imageUrl.isNotEmpty)
          .toList(growable: false);
    });
  }
}