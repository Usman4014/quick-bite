// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';

class ProductModel {
  final String id;

  final String name;

  final String description;

  final String image;

  /// Firestore category ID
  final String categoryId;

  /// Category name
  final String category;

  final bool isChefSpecial;

  final List<ProductVariantModel> variants;

  int totalOrders;

  RxBool isFavorite;

  ProductModel({
    required this.id,
    required this.totalOrders,
    required this.name,
    required this.description,
    required this.image,
    required this.categoryId,
    required this.category,
    required this.variants,
    bool isFavorite = false,
    this.isChefSpecial = false,
  }) : isFavorite = isFavorite.obs;
}