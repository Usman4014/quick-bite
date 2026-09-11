// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class ProductAppBar extends StatelessWidget {
  final ProductModel product;

  const ProductAppBar({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final ProductController productController =
        Get.find<ProductController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Back_Button(),

            Obx(
              () => GestureDetector(
                onTap: () {
                  productController.toggleFavorite(product);

                  Snack_Bar.show(
                    title: product.isFavorite.value
                        ? "Added to Favorites"
                        : "Removed from Favorites",
                    message: product.isFavorite.value
                        ? "${product.name} has been added to favorites"
                        : "${product.name} has been removed from favorites",
                    icon: product.isFavorite.value
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      product.isFavorite.value
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: product.isFavorite.value
                          ? AppColors.primary
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}