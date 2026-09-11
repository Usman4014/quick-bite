// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/PromoCode_Controller.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class CheckoutSummary extends StatelessWidget {
  CheckoutSummary({super.key});

  final CartController cartController = Get.find();
  final PromoCodeController promoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final offerDiscount = cartController.offerDiscount;
      final promoDiscount = cartController.promoDiscount;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //==========================================================
          // TITLE
          //==========================================================

          Text(
            "Order Summary",
            style: AppTextTheme.textfieldtitleText,
          ),

          const SizedBox(height: 5),

          //==========================================================
          // SUMMARY CARD
          //==========================================================

          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //======================================================
                // SUBTOTAL
                //======================================================

                _buildRow(
                  title: "Subtotal",
                  value:
                      "\$${cartController.subTotal.toStringAsFixed(2)}",
                ),

                const SizedBox(height: 12),

                //======================================================
                // OFFER DISCOUNT
                //======================================================

                if (offerDiscount > 0) ...[
                  _buildRow(
                    title: "Offer Discount",
                    value:
                        "-\$${offerDiscount.toStringAsFixed(2)}",
                    valueColor: Colors.green,
                  ),

                  const SizedBox(height: 12),
                ],

                //======================================================
                // DISCOUNTED SUBTOTAL
                //======================================================

               
                

                //======================================================
                // PROMO CODE
                //======================================================

                if (promoController.appliedPromoCode.value != null) ...[
                  

                  //====================================================
                  // PROMO DISCOUNT
                  //====================================================

                  if (promoDiscount > 0)
                    _buildRow(
                      title: "Promo Discount",
                      value:
                          "-\$${promoDiscount.toStringAsFixed(2)}",
                      valueColor: Colors.green,
                    ),

                  if (promoDiscount > 0)
                    const SizedBox(height: 12),
                ],

                //======================================================
                // FINAL SUBTOTAL
                //======================================================

              
                //======================================================
                // DELIVERY FEE
                //======================================================

                _buildRow(
                  title: "Delivery Fee",
                  value:
                      "+\$${cartController.deliveryFee.toStringAsFixed(2)}",
                ),

                const SizedBox(height: 12),

                //======================================================
                // TAX
                //======================================================

                _buildRow(
                  title: "Tax",
                  value:
                      "+\$${cartController.tax.toStringAsFixed(2)}",
                ),



                
              ],
            ),
          ),
        ],
      );
    });
  }

  //============================================================
  // SUMMARY ROW
  //============================================================

  Widget _buildRow({
    required String title,
    required String value,
    Color? valueColor,
    double titleFontSize = 14,
    double valueFontSize = 15,
    FontWeight titleFontWeight = FontWeight.normal,
    FontWeight valueFontWeight = FontWeight.w600,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: titleFontSize,
              fontWeight: titleFontWeight,
            ),
          ),
        ),

        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: valueFontWeight,
            fontSize: valueFontSize,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}