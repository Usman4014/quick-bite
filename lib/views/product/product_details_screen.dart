// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/views/product/product_add_to_cart_button.dart';
import 'package:quick_bite/views/product/product_appbar.dart';
import 'package:quick_bite/views/product/product_header.dart';
import 'package:quick_bite/views/product/product_image.dart';
import 'package:quick_bite/views/product/product_quantity.dart';
import 'package:quick_bite/views/product/product_reviews.dart';
import 'package:quick_bite/views/product/product_size_selector.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductModel product;

  ProductVariantModel? selectedVariant;

  int quantity = 1;

  @override
  void initState() {
    super.initState();

    final argument = Get.arguments;

    if (argument is ProductModel) {
      product = argument;

      if (product.variants.isNotEmpty) {
        selectedVariant = product.variants.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;

    // Safety check.
    if (argument is! ProductModel) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Unable to load product.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    // Safety check for products without variants.
    if (product.variants.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'This product has no available variants.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    final ProductVariantModel currentVariant =
        selectedVariant ?? product.variants.first;

    final double height = MediaQuery.of(context).size.height;

    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Stack(
          children: [
            //==========================================================
            // PRODUCT IMAGE
            //
            // The shimmer/loading behavior is handled INSIDE
            // ProductImage.
            //==========================================================

            ProductImage(product: product),

            //==========================================================
            // APP BAR
            //==========================================================
            ProductAppBar(product: product),

            //==========================================================
            // PRODUCT INFORMATION PANEL
            //==========================================================
            Column(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Container(
                  height: height * .60,
                  width: width,

                  decoration: BoxDecoration(
                    color: AppColors.background,

                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),

                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade600, blurRadius: 100),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          const SizedBox(height: 20),

                          //================================================
                          // PRODUCT HEADER
                          //================================================
                          ProductHeader(
                            product: product,
                            selectedVariant: currentVariant,
                          ),

                          //================================================
                          // PRODUCT SIZE / VARIANT
                          //================================================
                          ProductSizeSelector(
                            product: product,
                            selectedVariant: currentVariant,

                            onVariantSelected: (variant) {
                              setState(() {
                                selectedVariant = variant;
                              });
                            },
                          ),

                          //================================================
                          // QUANTITY
                          //================================================
                          ProductQuantity(
                            quantity: quantity,

                            onIncrease: () {
                              setState(() {
                                quantity++;
                              });
                            },

                            onDecrease: () {
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                              }
                            },
                          ),

                          //================================================
                          // REVIEWS
                          //================================================
                          ProductReviews(
                            product: product,

                            onSeeAll: () {
                              // Navigate later.
                            },
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //============================================================
            // ADD TO CART BUTTON
            //============================================================
            ProductAddToCartButton(
              product: product,
              selectedVariant: currentVariant,
              quantity: quantity,
            ),
          ],
        ),
      ),
    );
  }
}
