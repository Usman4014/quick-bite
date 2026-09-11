// ignore_for_file: file_names

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SpecialDealsModel {
  final String id;

  /// Deal Name
  final String title;

  /// Short Description
  final String description;

  /// Banner Image
  final String bannerImage;

  /// Square Image
  final String squareImage;

  /// Items included in the deal
  final List<String> items;

  int totalOrders;

  /// Original Price
  final double originalPrice;
  final bool isChefSpecial;

  /// Discounted Price
  final double dealPrice;
  RxBool isFavorite;
  
  // /// Minimum Order Amount to avail the deal
  // final double minimumOrderAmount;

  // /// Deal Start Date
  // final DateTime endDate;

  /// Discount Text
  /// Example: "Save 30%"
  final String discount;

  /// Extra Badge
  /// Example:
  /// "Limited Time"
  /// "Weekend Special"
  /// "Best Seller"
  final String specialNote;

  /// Featured on Home Screen
  final bool isFeatured;

  /// Whether deal is currently active
  final bool isActive;

   SpecialDealsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bannerImage,
    required this.squareImage,
    required this.totalOrders,
    required this.items,
    required this.originalPrice,
    required this.dealPrice,
    // required this.minimumOrderAmount,
    // required this.endDate,
    required this.discount,
    
    required this.specialNote,
    this.isChefSpecial = false,
    this.isFeatured = false,
    this.isActive = true,
    bool isFavorite = false,
  }): isFavorite = isFavorite.obs;

  /// Amount Saved
  double get savedAmount => originalPrice - dealPrice;

  /// Discount Percentage
  int get discountPercentage {
    if (originalPrice == 0) return 0;

    return ((savedAmount / originalPrice) * 100).round();
  }
}