// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Chef_Special_Controller.dart';
import 'package:quick_bite/models/Chef_Special_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/chefs_special/chef_special_card.dart';
import 'package:quick_bite/widgets/back_button.dart';

class ChefSpecialScreen extends StatelessWidget {
  ChefSpecialScreen({super.key});

  final ChefSpecialController chefSpecialController=Get.find<ChefSpecialController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //==================================================
      // Products + Special Deals
      //==================================================
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            App_Bar(),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
               
                //================================================
                // Empty State
                //================================================

                if (chefSpecialController.chefSpecials.isEmpty) {
                  return Center(
                    child: Text(
                      "No Chefs Special available.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount:chefSpecialController.chefSpecials.length,
                  itemBuilder: (context, index) {
                    final ChefSpecialModel item = chefSpecialController.chefSpecials[index];

                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: () {
                          //========================================
                          // Product
                          //========================================
                      
                          //========================================
                          // Special Deal
                          //========================================
                      
                          if (item.isSpecialDeal) {
                            Get.toNamed(
                              AppRoutes.specialDealDetails,
                              arguments: item.specialDeal,
                            );
                          } else {
                            Get.toNamed(
                              AppRoutes.productdetailsscreen,
                              arguments: item.product,
                            );
                          }
                        },
                      
                        child: ChefSpecialCard(item: item),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget App_Bar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),
            SizedBox(width: 15),
            Text("Chef's Special", style: AppTextTheme.appbarText),
          ],
        ),
      ),
    );
  }
}
