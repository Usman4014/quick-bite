// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class DealInfo extends StatelessWidget {
  final SpecialDealsModel deal;

  const DealInfo({
    super.key,
    required this.deal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _DealInfoRow(
            icon: Icons.sell_outlined,
            title: "Original Price",
            value: "\$${deal.originalPrice.toStringAsFixed(2)}",
          ),

          const SizedBox(height: 15),

          _DealInfoRow(
            icon: Icons.local_offer_outlined,
            title: "Deal Price",
            value: "\$${deal.dealPrice.toStringAsFixed(2)}",
          ),

          const SizedBox(height: 15),

          _DealInfoRow(
            icon: Icons.savings_outlined,
            title: "You Save",
            value: "\$${deal.savedAmount.toStringAsFixed(2)}",
          ),

          const SizedBox(height: 15),

          _DealInfoRow(
            icon: Icons.discount_outlined,
            title: "Discount",
            value: "${deal.discountPercentage.toStringAsFixed(0)}%",
          ),
        ],
      ),
    );
  }
}

class _DealInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DealInfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primary,
          size: 22,
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),

        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}