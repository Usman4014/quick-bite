// ignore_for_file: file_names

import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/models/Notification_Model.dart';
import 'package:quick_bite/models/PaymentMethod_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final List<AddressModel> addresses;
  final List<ProductModel> favoriteProducts;
  final List<PaymentMethodModel> paymentMethods;
  final List<NotificationModel> notifications;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.addresses,
    required this.favoriteProducts,
    required this.paymentMethods,
    required this.notifications,
  });
}

