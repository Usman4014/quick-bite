
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              //==================================================
              // Subtotal
              //==================================================
      
              _summaryRow(
                "Subtotal",
                "\$${cartController.subTotal.toStringAsFixed(2)}",
              ),
      
              const SizedBox(height: 12),
      
              //==================================================
              // Offer Discount
              //==================================================
      
              if (cartController.offerDiscount > 0) ...[
                _summaryRow(
                  "Offer Discount",
                  "-\$${cartController.offerDiscount.toStringAsFixed(2)}",
                  valueColor: Colors.green,
                ),
      
                const SizedBox(height: 12),
      
                
              ],
      
              //==================================================
              // Delivery Fee
              //==================================================
      
              _summaryRow(
                "Delivery Fee",
                "\$${cartController.deliveryFee.toStringAsFixed(2)}",
              ),
      
              const SizedBox(height: 12),
      
              //==================================================
              // Tax
              //==================================================
      
              _summaryRow(
                "Tax",
                "\$${cartController.tax.toStringAsFixed(2)}",
              ),
      
            
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool isBold = false,
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal || isBold
                ? FontWeight.w600
                : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey.shade600,
          ),
        ),

        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 17 : 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

