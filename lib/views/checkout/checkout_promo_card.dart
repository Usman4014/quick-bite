// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/PromoCode_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/checkout/promo_code_bottom_sheet.dart';

class CheckoutPromoCard extends StatelessWidget {
  CheckoutPromoCard({super.key});

  final PromoCodeController promoCodeController =
      Get.find<PromoCodeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final appliedPromo = promoCodeController.appliedPromoCode.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Promo Code", style: AppTextTheme.textfieldtitleText),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  Get.bottomSheet(
                    const PromoCodeBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: Row(
                    children: [
                      FaIcon(FontAwesomeIcons.tags,color: AppColors.primary,size: 20,),
          
                      const SizedBox(width: 12),
          
                      Expanded(
                        child: appliedPromo == null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Promo Code",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "Tap to view available promo codes",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appliedPromo.code,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    appliedPromo.description,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
          
                      if (appliedPromo != null)
                        const Icon(Icons.check_circle, color:AppColors.primary)
                      else
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
