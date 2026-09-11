// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Offer_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_Colors.dart';
import 'package:quick_bite/theme/App_TextTheme.dart';
import 'package:quick_bite/views/landing/offers/empty_offer.dart';
import 'package:quick_bite/views/landing/offers/featured_offer_banner.dart';
import 'package:quick_bite/views/landing/offers/offer_card.dart';

class OffersScreen extends StatelessWidget {
  OffersScreen({super.key});

  final OfferController offerController = Get.find<OfferController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            App_Bar(),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (offerController.activeOffers.isEmpty) {
                  return const EmptyOffer();
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //==================================================
                        // Featured Banner
                        //==================================================
                        const FeaturedOfferBanner(),

                        const SizedBox(height: 30),

                        //==================================================
                        // Available Offers
                        //==================================================
                        Text("Available Offers", style: AppTextTheme.titleText),

                        const SizedBox(height: 15),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: offerController.activeOffers.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final offer = offerController.activeOffers[index];

                            return OfferCard(
                              offer: offer,
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.offerDetails,
                                  arguments: offer,
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget App_Bar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Offers', style: AppTextTheme.appbarText),
              Text(
                'Saev more on every order',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
