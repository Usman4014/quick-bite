import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/special_deals/special_deals_card.dart';

import 'package:quick_bite/widgets/back_button.dart';

class SpecialDealsScreen extends StatelessWidget {
  const SpecialDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpecialDealsController controller =
        Get.find<SpecialDealsController>();

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              AppBar(),
              SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.specialDeals.isEmpty) {
                    return Center(
                      child: Text(
                        "No Special Deals Available",

                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.specialDeals.length,
                    itemBuilder: (context, index) {
                      final deal = controller.specialDeals[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SpecialDealsCard(deal: deal),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget AppBar() {
    return SafeArea(
      child: Row(
        children: [
          Back_Button(),
          SizedBox(width: 15),
          Text('Special Deals', style: AppTextTheme.appbarText),
        ],
      ),
    );
  }
}
