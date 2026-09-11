// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/controllers/Offer_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';

class CartOfferCard extends StatelessWidget {
 CartOfferCard({super.key});

  final LandingController landingController=Get.find<LandingController>();

  @override
  Widget build(BuildContext context) {
    final OfferController offerController = Get.find();

    return Obx(() {
      final offer = offerController.appliedOffer.value;

      //==========================================================
      // NO OFFER ACTIVATED
      //==========================================================

      if (offer == null) {
        return GestureDetector(
          onTap: (){
landingController.changeTab(3);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                //================================================
                // Icon
                //================================================
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.tags,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
          
                const SizedBox(width: 13),
          
                //================================================
                // Text
                //================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unlock More Savings!",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
          
                      const SizedBox(height: 4),
          
                      Text(
                        "Check out our offers and add more items to unlock exclusive discounts.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(width: 8),
          
                //================================================
                // Arrow
                //================================================
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      //==========================================================
      // OFFER ACTIVATED
      //==========================================================

      final discount = offerController.appliedOfferDiscount.value;

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            //==================================================
            // Offer Icon
            //==================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.gift,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
            ),
      
           
      
            //==================================================
            // Offer Information
            //==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          offer.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
      
                      const SizedBox(width: 8),
      
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Applied',
                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const FaIcon(
                              FontAwesomeIcons.solidCircleCheck,
                              color: AppColors.primary,
                              size: 11,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      
                  const SizedBox(height: 10),
      
                  Text(
                    'Automatic offer applied to your order',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
      
                  const SizedBox(height: 3),
      
                  Row(
                    children: [
                      Text(
                        "You Saved: ",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "\$${discount.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
