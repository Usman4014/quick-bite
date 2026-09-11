// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class ProductAddToCartButton extends StatelessWidget {
  final ProductModel product;
  final ProductVariantModel selectedVariant;
  final int quantity;

  const ProductAddToCartButton({
    super.key,
    required this.product,
    required this.selectedVariant,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final LandingController landingController =
        Get.find<LandingController>();

    final double totalPrice = selectedVariant.price * quantity;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                cartController.addToCart(
                  CartItemModel(
                    product: product,
                    selectedVariant: selectedVariant,
                    quantity: quantity,
                  ),
                );

                landingController.changeTab(2);

                Snack_Bar.show(
                  title: "Added to Cart",
                  message: "${product.name} has been added to cart",
                  icon: FontAwesomeIcons.cartPlus,
                );

                Get.until(
                  (route) =>
                      route.settings.name == AppRoutes.landing,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add to Cart",
                    style: AppTextTheme.titleText,
                  ),

                  Text(
                    "Total: \$${totalPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}