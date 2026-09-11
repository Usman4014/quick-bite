// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/widgets/Snack_Bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OrderReorderButton extends StatelessWidget {
  final OrderModel order;

  const OrderReorderButton({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.shopping_cart_checkout,
          color: Colors.black,
        ),
        label: Text(
          "Reorder",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onPressed: () {
          //--------------------------------------------------
          // Add every previous item back to cart
          //--------------------------------------------------

          for (final item in order.items) {
            cartController.cartItems.add(
              CartItemModel(
                product: item.product,
                selectedVariant: item.variant,
                quantity: item.quantity,
                
              ),
            );
          }

          //--------------------------------------------------
          // Success
          //--------------------------------------------------

          Snack_Bar.show(
            title: "Added to Cart",
            message: "Items have been added to your cart.",
            icon: FontAwesomeIcons.cartShopping,
          );

          //--------------------------------------------------
          // Go to Cart tab
          //--------------------------------------------------

          final landingController = Get.find<LandingController>();

          landingController.changeTab(2);

          Get.until(
            (route) => route.settings.name == AppRoutes.landing,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}