// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/theme/App_Colors.dart';
import 'package:quick_bite/views/landing/offers/offer_image_section.dart';
import 'package:quick_bite/views/landing/offers/offer_info_card.dart';
import 'package:quick_bite/views/landing/offers/offer_terms_section.dart';
import 'package:quick_bite/views/landing/offers/offer_bottom_bar.dart';
import 'package:quick_bite/widgets/back_button.dart';

class OfferDetailsScreen extends StatelessWidget {
  final OfferModel offer;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //==========================================================
      // ORDER NOW BUTTON
      //==========================================================

      bottomNavigationBar: OfferBottomBar(
        offer: offer,
      ),

      //==========================================================
      // BODY
      //==========================================================

      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                OfferImageSection(
                  offer: offer,
                ),

                const SizedBox(height: 20),

                OfferInfoCard(
                  offer: offer,
                ),

                const SizedBox(height: 20),

                OfferTermsSection(
                  offer: offer,
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          //========================================================
          // APP BAR
          //========================================================

          SafeArea(
            child: App_Bar(),
          ),
        ],
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget App_Bar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          children: [
            Back_Button(),
          ],
        ),
      ),
    );
  }
}