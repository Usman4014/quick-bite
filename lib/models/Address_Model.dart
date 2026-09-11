// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/AddressTypeVariant_Model.dart';

class AddressModel {
  final String id;
  final String phoneNumber;
  final AddressTypeVariantModel addressType;

  final String streetAddress;
  final String? apartment;
  final String neighborhood;
  final String? deliveryInstructions;

  bool isDefault;
  bool isSelected;

  final double latitude;
  final double longitude;

  AddressModel({
    required this.id,
    required this.phoneNumber,
    required this.addressType,
    required this.streetAddress,
    this.apartment,
    required this.neighborhood,
    this.deliveryInstructions,
    required this.isDefault,
    required this.isSelected,
    required this.latitude,
    required this.longitude,
  });

  //============================================================
  // FIRESTORE → MODEL
  //============================================================

  factory AddressModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return AddressModel(
      id: document.id,

      phoneNumber:
          data['phoneNumber']?.toString() ?? '',

      addressType:
          AddressTypeVariantModel.fromMap(
        data['addressType']
            as Map<String, dynamic>? ??
            {},
      ),

      streetAddress:
          data['streetAddress']?.toString() ?? '',

      apartment:
          data['apartment']?.toString(),

      neighborhood:
          data['neighborhood']?.toString() ?? '',

      deliveryInstructions:
          data['deliveryInstructions']?.toString(),

      isDefault:
          data['isDefault'] as bool? ?? false,

      isSelected:
          data['isSelected'] as bool? ?? false,

      latitude:
          _doubleValue(data['latitude']),

      longitude:
          _doubleValue(data['longitude']),
    );
  }

  //============================================================
  // MODEL → FIRESTORE
  //============================================================

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'addressType': addressType.toMap(),
      'streetAddress': streetAddress,
      'apartment': apartment,
      'neighborhood': neighborhood,
      'deliveryInstructions':
          deliveryInstructions,
      'isDefault': isDefault,
      'isSelected': isSelected,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  //============================================================
  // NUMBER CONVERTER
  //============================================================

  static double _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }
}