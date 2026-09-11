// ignore_for_file: file_names

import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

class ChefSpecialModel {
  final ProductModel? product;
  final SpecialDealsModel? specialDeal;

  const ChefSpecialModel({
    this.product,
    this.specialDeal,
  }) : assert(
         product != null || specialDeal != null,
         "Either product or specialDeal must be provided.",
       );

  //----------------------------------------------------------
  // Type
  //----------------------------------------------------------

  bool get isSpecialDeal => specialDeal != null;

  //----------------------------------------------------------
  // Common Getters
  //----------------------------------------------------------

  String get id =>
      isSpecialDeal ? specialDeal!.id : product!.id;

  String get title =>
      isSpecialDeal ? specialDeal!.title : product!.name;

  String get description =>
      isSpecialDeal
          ? specialDeal!.description
          : product!.description;

  /// Uses the square image for both products and deals
  String get image =>
      isSpecialDeal
          ? specialDeal!.squareImage
          : product!.image;

  double get price =>
      isSpecialDeal
          ? specialDeal!.dealPrice
          : product!.variants.first.price;

  double? get originalPrice =>
      isSpecialDeal
          ? specialDeal!.originalPrice
          : null;

  bool get isFavorite =>
      isSpecialDeal
          ? specialDeal!.isFavorite.value
          : product!.isFavorite.value;
}