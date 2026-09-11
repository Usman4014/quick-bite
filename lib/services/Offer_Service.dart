// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/Offer_Model.dart';

class OfferService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // OFFERS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get _offersCollection =>
          _firestore.collection('offers');

  //============================================================
  // GET ACTIVE OFFERS
  //============================================================

  Stream<List<OfferModel>> getOffersStream() {
    return _offersCollection
        .where(
          'isActive',
          isEqualTo: true,
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map(
            (document) =>
                OfferModel.fromFirestore(document),
          )
          .toList();
    });
  }
}