// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class DealAddToCartButton extends StatelessWidget {
  final SpecialDealsModel deal;

  const DealAddToCartButton({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final LandingController landingController = Get.find<LandingController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                cartController.addToCart(
                  CartItemModel(specialDeal: deal, quantity: 1),
                );

                landingController.changeTab(2);

                Snack_Bar.show(
                  title: "Added to Cart",
                  message: "${deal.title} has been added to cart",
                  icon: FontAwesomeIcons.cartPlus,
                );

                Get.until((route) => route.settings.name == AppRoutes.landing);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add to Cart", style: AppTextTheme.titleText),

                  Text(
                    "Total \$${deal.dealPrice.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
