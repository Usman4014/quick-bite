// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(
      () => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                
                 Get.toNamed(AppRoutes.checkout);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Proceed to Checkout",
                    style: AppTextTheme.titleText,
                  ),

                   Text(
                 
                   "\$${cartController.totalAmount.toStringAsFixed(2)}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
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
      ),
    );
  }
}