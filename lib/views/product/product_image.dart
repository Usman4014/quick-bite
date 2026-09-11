// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/shimmers/product_image_with_shimmer.dart';


class ProductImage extends StatelessWidget {
  final ProductModel product;

  const ProductImage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ProductImageWithShimmer(
      imageUrl: product.image,
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      fit: BoxFit.contain,
    );
  }
}