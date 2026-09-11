// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_Colors.dart';

class OfferBottomBar extends StatelessWidget {
  final OfferModel offer;

  const OfferBottomBar({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleOrderNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_bag_outlined),
                const SizedBox(width: 10),
                Text(
                  'Order Now',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //============================================================
  // ORDER NOW
  //============================================================

  void _handleOrderNow() {
    if (offer.categoryId == null || offer.categoryId!.isEmpty) {
      Get.snackbar('Offer Error', 'This offer is not linked to a category.');
      return;
    }

    Get.toNamed(
      AppRoutes.listofproducts,
      arguments: {'categoryId': offer.categoryId!},
    );
  }
}
