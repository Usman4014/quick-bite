// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/theme/App_Colors.dart';

class OfferTermsSection extends StatelessWidget {
  final OfferModel offer;

  const OfferTermsSection({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
      
        padding: const EdgeInsets.all(20),
      
        decoration: BoxDecoration(
          color: Colors.white,
      
          borderRadius: BorderRadius.circular(15),
      
          border: Border.all(color: Colors.grey.shade300)
        ),
      
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      
          children: [
            //==================================================
            // Title
            //==================================================
      
            Text(
              "Terms & Conditions",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      
            const SizedBox(height: 18),
      
            //==================================================
            // Terms
            //==================================================
      
            ...offer.terms.map(
              (term) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
      
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
      
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 18,
                    ),
      
                    const SizedBox(width: 12),
      
                    Expanded(
                      child: Text(
                        term,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}