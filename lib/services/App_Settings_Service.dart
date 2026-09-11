// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/App_Settings_Model.dart';

class AppSettingsService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //============================================================
  // SETTINGS DOCUMENT
  //============================================================

  DocumentReference<Map<String, dynamic>> get _settingsDocument {
    return _firestore.collection('settings').doc('restaurant');
  }

  //============================================================
  // GET SETTINGS
  //============================================================

  Future<AppSettingsModel> getSettings() async {
    final document = await _settingsDocument.get();

    //==========================================================
    // DOCUMENT DOES NOT EXIST
    //==========================================================

    if (!document.exists) {
      return AppSettingsModel.defaults();
    }

    //==========================================================
    // FIRESTORE DATA
    //==========================================================

    final data = document.data() ?? {};

    return _fromMap(data);
  }

  //============================================================
  // LISTEN TO SETTINGS
  //============================================================

  Stream<AppSettingsModel> settingsStream() {
    return _settingsDocument.snapshots().map((document) {
      if (!document.exists) {
        return AppSettingsModel.defaults();
      }

      final data = document.data() ?? {};

      return _fromMap(data);
    });
  }

  //============================================================
  // CONVERT FIRESTORE → MODEL
  //============================================================

  AppSettingsModel _fromMap(Map<String, dynamic> data) {
    return AppSettingsModel(
      //========================================================
      // RESTAURANT INFORMATION
      //========================================================

      restaurantName: data['restaurantName']?.toString() ?? 'Quick Bite',

      restaurantPhone: data['restaurantPhone']?.toString() ?? '',

      restaurantEmail: data['restaurantEmail']?.toString() ?? '',

      restaurantAddress: data['restaurantAddress']?.toString() ?? '',

      restaurantLatitude: _doubleValue(data['restaurantLatitude'], 0.0),

      restaurantLongitude: _doubleValue(data['restaurantLongitude'], 0.0),

      //========================================================
      // DELIVERY
      //========================================================
      deliveryRadius: _doubleValue(data['deliveryRadius'], 10.0),

      deliveryFee: _doubleValue(data['deliveryFee'], 0.0),

      minimumOrderAmount: _doubleValue(data['minimumOrderAmount'], 0.0),

      estimatedDeliveryMinutes: _intValue(data['estimatedDeliveryMinutes'], 30),

      //========================================================
      // ORDERS
      //========================================================
      acceptOrders: data['acceptOrders'] as bool? ?? true,

      allowCancellation: data['allowCancellation'] as bool? ?? true,

      preparationTimeMinutes: _intValue(data['preparationTimeMinutes'], 20),

      //========================================================
      // PAYMENTS
      //========================================================
      cashOnDelivery: data['cashOnDelivery'] as bool? ?? true,

      onlinePayment: data['onlinePayment'] as bool? ?? false,

      //========================================================
      // NOTIFICATIONS
      //========================================================
      newOrderNotifications: data['newOrderNotifications'] as bool? ?? true,

      orderStatusNotifications:
          data['orderStatusNotifications'] as bool? ?? true,

      //========================================================
      // APP
      //========================================================
      maintenanceMode: data['maintenanceMode'] as bool? ?? false,

      appAvailable: data['appAvailable'] as bool? ?? true,
    );
  }

  //============================================================
  // DOUBLE CONVERTER
  //============================================================

  double _doubleValue(dynamic value, double fallback) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  //============================================================
  // INTEGER CONVERTER
  //============================================================

  int _intValue(dynamic value, int fallback) {
    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }

    return fallback;
  }
}
