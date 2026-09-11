// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AddressNeighborhoodModel {
  final String id;
  final String title;

  const AddressNeighborhoodModel({
    required this.id,
    required this.title,
  });

  //============================================================
  // FIRESTORE → MODEL
  //============================================================

  factory AddressNeighborhoodModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return AddressNeighborhoodModel(
      id: document.id,
      title: document.data()?['title']?.toString() ?? '',
    );
  }

  //============================================================
  // MAP → MODEL
  //============================================================

  factory AddressNeighborhoodModel.fromMap(
    Map<String, dynamic> data, {
    String? id,
  }) {
    return AddressNeighborhoodModel(
      id: id ?? data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
    );
  }

  //============================================================
  // MODEL → FIRESTORE
  //============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}