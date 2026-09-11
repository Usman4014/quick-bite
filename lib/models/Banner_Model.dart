// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String image;

  BannerModel({
    required this.id,
    required this.image,
  });

  //============================================================
  // FROM FIRESTORE
  //============================================================

  factory BannerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return BannerModel(
      id: document.id,
      image: data['imageUrl']?.toString() ?? '',
    );
  }
}