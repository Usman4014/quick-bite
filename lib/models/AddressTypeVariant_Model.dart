// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddressTypeVariantModel {
  final String id;
  final String title;
  final String iconKey;

  AddressTypeVariantModel({
    required this.id,
    required this.title,
    required this.iconKey,
  });

  //============================================================
  // ICON
  //============================================================

  FaIconData get icon {
    switch (iconKey) {
      case 'home':
        return FontAwesomeIcons.house;

      case 'work':
        return FontAwesomeIcons.briefcase;

      case 'office':
        return FontAwesomeIcons.building;

      case 'school':
        return FontAwesomeIcons.graduationCap;

      case 'other':
        return FontAwesomeIcons.locationDot;

      default:
        return FontAwesomeIcons.locationDot;
    }
  }

  //============================================================
  // FIRESTORE → MODEL
  //============================================================

  factory AddressTypeVariantModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return AddressTypeVariantModel.fromMap(
      document.data() ?? {},
      id: document.id,
    );
  }

  //============================================================
  // MAP → MODEL
  //============================================================

  factory AddressTypeVariantModel.fromMap(
    Map<String, dynamic> data, {
    String? id,
  }) {
    return AddressTypeVariantModel(
      id: id ?? data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      iconKey: data['iconKey']?.toString() ?? 'other',
    );
  }

  //============================================================
  // MODEL → FIRESTORE
  //============================================================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconKey': iconKey,
    };
  }
}