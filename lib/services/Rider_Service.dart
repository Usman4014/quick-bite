// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/Rider_Model.dart';

class RiderService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // RIDERS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _ridersCollection =>
      _firestore.collection('riders');

  //============================================================
  // LISTEN TO RIDERS
  //============================================================

  Stream<List<RiderModel>> listenToRiders() {
    return _ridersCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (document) => _mapRider(
                document.id,
                document.data(),
              ),
            )
            .toList(growable: false);
      },
    );
  }

  //============================================================
  // GET SINGLE RIDER
  //============================================================

  Future<RiderModel?> getRider(String riderId) async {
    final document = await _ridersCollection.doc(riderId).get();

    if (!document.exists) {
      return null;
    }

    return _mapRider(
      document.id,
      document.data() ?? const {},
    );
  }

  //============================================================
  // UPDATE RIDER AVAILABILITY
  //============================================================

  Future<void> updateAvailability({
    required String riderId,
    required bool isAvailable,
  }) async {
    await _ridersCollection.doc(riderId).update({
      'isAvailable': isAvailable,
    });
  }

  //============================================================
  // MAP FIRESTORE → RIDER MODEL
  //============================================================

  RiderModel _mapRider(
    String id,
    Map<String, dynamic> data,
  ) {
    return RiderModel(
      id: id,
      name: data['name']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      profileImage: data['profileImage']?.toString() ?? '',
      vehicleType: data['vehicleType']?.toString() ?? '',
      vehicleNumber: data['vehicleNumber']?.toString() ?? '',
      rating: _doubleValue(
        data['rating'],
        0.0,
      ),
      isAvailable: data['isAvailable'] as bool? ?? true,
    );
  }

  //============================================================
  // SAFE DOUBLE CONVERSION
  //============================================================

  double _doubleValue(
    dynamic value,
    double fallback,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }

    return fallback;
  }
}