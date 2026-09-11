// ignore_for_file: file_names

import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

class PopularItemModel {
  /// Either a Product OR a Special Deal
  final ProductModel? product;
  final SpecialDealsModel? specialDeal;

  PopularItemModel({
    this.product,
    this.specialDeal,
  });

  /// True if this item is a Special Deal
  bool get isSpecialDeal => specialDeal != null;

  /// Display Name
  String get title =>
      isSpecialDeal ? specialDeal!.title : product!.name;

  /// Display Image
  String get image =>
      isSpecialDeal ? specialDeal!.bannerImage : product!.image;

  /// Display Price
  double get price =>
      isSpecialDeal
          ? specialDeal!.dealPrice
          : product!.variants.first.price;

  /// Number of times ordered
  int get totalOrders =>
      isSpecialDeal
          ? specialDeal!.totalOrders
          : product!.totalOrders;
}