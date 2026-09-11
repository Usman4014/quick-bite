// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

class CartItemModel {
  ProductModel? product;

  SpecialDealsModel? specialDeal;

  ProductVariantModel? selectedVariant;

  RxInt quantity;

  CartItemModel({
    this.product,
    this.specialDeal,
    this.selectedVariant,
    int quantity = 1,
  }) : quantity = quantity.obs;

  double get unitPrice {
    if (product != null) {
      return selectedVariant!.price;
    }

    return specialDeal!.dealPrice;
  }

  double get totalPrice {
    return unitPrice * quantity.value;
  }
}