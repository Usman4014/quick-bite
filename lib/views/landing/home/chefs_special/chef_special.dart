// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Chef_Special_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/shimmers/chef_special_shimmer.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/chefs_special/chef_special_card.dart';

class ChefSpecial extends StatelessWidget {
  ChefSpecial({super.key});

  final ChefSpecialController chefSpecialController =
      Get.find<ChefSpecialController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //========================================================
        // TITLE + VIEW ALL
        //========================================================

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chef's Special",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.chefsSpecial);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text("View All", style: AppTextTheme.textButton),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        //========================================================
        // CHEF'S SPECIAL
        //========================================================
        Obx(() {
          //======================================================
          // LOADING
          //======================================================

          if (chefSpecialController.isLoading.value) {
            return const ChefSpecialShimmer();
          }

          //======================================================
          // EMPTY
          //======================================================

          if (chefSpecialController.chefSpecials.isEmpty) {
            return SizedBox(
              height: 120,
              width: double.infinity,
              child: Center(
                child: Text(
                  "No chef's special yet.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            );
          }

          //======================================================
          // HORIZONTAL LIST
          //======================================================

          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(
                  chefSpecialController.chefSpecials.length,
                  (index) {
                    final item = chefSpecialController.chefSpecials[index];

                    return ChefSpecialCard(item: item);
                  },
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
