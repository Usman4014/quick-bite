// ignore_for_file: file_names

import 'package:quick_bite/enums/Payment_Method.dart';

class PaymentMethodModel {
  String id;

  PaymentMethod paymentMethod;

  String title;

  String? cardHolderName;

  String? cardNumber;

  String? expiryDate;

  String? cvv;

  bool isDefault;
  bool isSelected;

  PaymentMethodModel({
    required this.id,
    required this.paymentMethod,
    required this.title,
    this.cardHolderName,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.isDefault = false,
    required this.isSelected,
  });
}