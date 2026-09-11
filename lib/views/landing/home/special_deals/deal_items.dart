// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class DealItems extends StatelessWidget {
  final SpecialDealsModel deal;

  const DealItems({
    super.key,
    required this.deal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Included Items",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 15),

        Container(
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
            children: List.generate(
              deal.items.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == deal.items.length - 1 ? 0 : 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 20,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        deal.items[index],
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}