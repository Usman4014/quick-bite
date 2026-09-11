// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:quick_bite/enums/Offer_Discount_Type.dart';
import 'package:quick_bite/enums/Offer_Target.dart';
import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/theme/App_Colors.dart';

class OfferInfoCard extends StatelessWidget {
  final OfferModel offer;

  const OfferInfoCard({
    super.key,
    required this.offer,
  });

  //============================================================
  // DISCOUNT TEXT
  //============================================================

  String get discountText {
    switch (offer.discountType) {
      case OfferDiscountType.percentage:
        return "${offer.discountValue.toInt()}% OFF";

      case OfferDiscountType.flat:
        return "\$${offer.discountValue.toInt()} OFF";
    }
  }

  //============================================================
  // TARGET TEXT
  //============================================================

  String get targetText {
    if (offer.target == OfferTarget.categories) {
      if (offer.categoryId == null ||
          offer.categoryId!.isEmpty) {
        return "Category";
      }

      return "Selected Category";
    }

    return "Category";
  }

  //============================================================
  // EXPIRY
  //============================================================

  bool get isExpired {
    return DateTime.now().isAfter(offer.endDate);
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),

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
            //==================================================
            // TITLE
            //==================================================

            Text(
              offer.title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            //==================================================
            // DESCRIPTION
            //==================================================

            Text(
              offer.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const SizedBox(height: 10),

            //==================================================
            // DISCOUNT
            //==================================================

            _infoRow(
              Icons.local_offer_outlined,
              "Discount",
              discountText,
            ),

            //==================================================
            // APPLIES TO
            //==================================================

            _infoRow(
              Icons.category_outlined,
              "Applies To",
              targetText,
            ),

            //==================================================
            // VALID UNTIL
            //==================================================

            _infoRow(
              Icons.calendar_today_outlined,
              "Valid Until",
              DateFormat(
                "MMM dd, yyyy",
              ).format(
                offer.endDate,
              ),
            ),

            //==================================================
            // MINIMUM ORDER
            //==================================================

            _infoRow(
              Icons.shopping_bag_outlined,
              "Minimum Order",
              "\$${offer.minimumOrderAmount.toInt()}",
            ),

            //==================================================
            // STATUS
            //==================================================

            _infoRow(
              Icons.circle,
              "Status",
              isExpired ? "Expired" : "Active",
              valueColor:
                  isExpired ? Colors.red : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // INFO ROW
  //============================================================

  Widget _infoRow(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Row(
        children: [
          //====================================================
          // ICON
          //====================================================

          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),

          const SizedBox(width: 12),

          //====================================================
          // TITLE
          //====================================================

          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          ),

          //====================================================
          // VALUE
          //====================================================

          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}