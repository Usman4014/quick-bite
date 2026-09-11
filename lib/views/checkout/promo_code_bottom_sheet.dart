// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/PromoCode_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class PromoCodeBottomSheet extends StatelessWidget {
  const PromoCodeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final PromoCodeController promoCodeController =
        Get.find<PromoCodeController>();

    return Container(
      height: MediaQuery.of(context).size.height * .75,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),

          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Choose Promo Code",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Obx(() {
              final promoCodes = promoCodeController.activePromoCodes;

              if (promoCodes.isEmpty) {
                return Center(
                  child: Text(
                    "No promo codes available",
                    style: GoogleFonts.poppins(),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                physics: const BouncingScrollPhysics(),
                itemCount: promoCodes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final promo = promoCodes[index];

                  final isApplied =
                      promoCodeController.appliedPromoCode.value?.id ==
                      promo.id;

                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isApplied
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.tag,
                              color: AppColors.primary,
                              size: 22,
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                promo.code,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            if (isApplied)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          promo.description,
                          style: GoogleFonts.poppins(
                            color: Colors.grey.shade900,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Minimum Order: \$${promo.minimumOrderAmount.toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                         onPressed: isApplied
    ? null
    : () async {
        final success =
            promoCodeController.applyPromoCode(promo.code);

        if (success) {
          Get.back();

          await Future.delayed(const Duration(milliseconds: 250));

          Snack_Bar.show(
            title: "Promo Applied",
            message: "${promo.code} applied successfully.",
            icon: FontAwesomeIcons.circleCheck,
          );
        }
    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              disabledBackgroundColor: Colors.grey.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text(
                              isApplied ? "Applied" : "Apply",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
