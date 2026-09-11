// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Popular_Item_Controller.dart';
import 'package:quick_bite/models/Popular_Item_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/popular_right_now/popular_item_card.dart';
import 'package:quick_bite/widgets/back_button.dart';

class PopularRightNowScreen extends StatelessWidget {
  PopularRightNowScreen({super.key});

  final PopularItemController popularItemController =
      Get.find<PopularItemController>();

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

                if (popularItemController.popularItems.isEmpty) {
                  return Center(
                    child: Text(
                      "No popular items available.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: popularItemController.popularItems.length,
                  itemBuilder: (context, index) {
                    final PopularItemModel item =
                        popularItemController.popularItems[index];

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

                        child: PopularItemCard(item: item),
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
            Text('Popular Right Now', style: AppTextTheme.appbarText),
          ],
        ),
      ),
    );
  }
}
