// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class OrderPriceSummary extends StatelessWidget {
  final OrderModel order;

  const OrderPriceSummary({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Summary", style: AppTextTheme.textfieldtitleText),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //==================================================
              // SUBTOTAL
              //==================================================
              _priceRow("Subtotal", order.subtotal),

              //==================================================
              // OFFER DISCOUNT
              //==================================================
              if (order.offerDiscount > 0) ...[
                const SizedBox(height: 12),

                _priceRow(
                  "Offer Discount",
                  -order.offerDiscount,
                  valueColor: Colors.green,
                ),
              ],

              //==================================================
              // PROMO DISCOUNT
              //==================================================
              if (order.promoDiscount > 0) ...[
                const SizedBox(height: 12),

                _priceRow(
                  "Promo Discount",
                  -order.promoDiscount,
                  valueColor: Colors.green,
                ),
              ],

              //==================================================
              // DELIVERY FEE
              //==================================================
              const SizedBox(height: 12),

              _priceRow("Delivery Fee", order.deliveryFee, displayPlus: true),

              //==================================================
              // TAX
              //==================================================
              const SizedBox(height: 12),

              _priceRow("Tax", order.tax, displayPlus: true),

              //==================================================
              // DIVIDER
              //==================================================
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Divider(height: 1),
              ),

              //==================================================
              // TOTAL PAID
              //==================================================
              _priceRow("Total Paid", order.totalAmount, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  //============================================================
  // PRICE ROW
  //============================================================

  Widget _priceRow(
    String title,
    double amount, {
    bool isTotal = false,
    bool displayPlus = false,
    Color? valueColor,
  }) {
    final bool isDiscount = amount < 0;

    final String prefix = isDiscount
        ? "-"
        : displayPlus
        ? "+"
        : "";

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w600 : null,
              color: isTotal ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ),

        Text(
          "$prefix\$${amount.abs().toStringAsFixed(2)}",
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 17 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isTotal ? AppColors.primary : Colors.black),
          ),
        ),
      ],
    );
  }
}
