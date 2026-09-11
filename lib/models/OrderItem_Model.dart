// ignore_for_file: file_names

import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

class OrderItemModel {
  final ProductModel? product;
  final ProductVariantModel? variant;

  final SpecialDealsModel? specialDeal;

  final int quantity;

  final double unitPrice;

  final String? notes;

  double get totalPrice => quantity * unitPrice;

  bool get isSpecialDeal => specialDeal != null;

  OrderItemModel({
    this.product,
    this.variant,
    this.specialDeal,
    required this.quantity,
    required this.unitPrice,
    this.notes,
  });
}