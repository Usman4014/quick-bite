// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Popular_Item_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/shimmers/popular_right_now_shimmer.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/popular_right_now/popular_item_card.dart';

class PopularRightNow extends StatelessWidget {
  PopularRightNow({super.key});

  final PopularItemController popularController =
      Get.find<PopularItemController>();

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
                "Popular Right Now",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),

              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.popularRightNow);
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
        // POPULAR ITEMS
        //========================================================
        Obx(() {
          //======================================================
          // LOADING
          //======================================================

          if (popularController.isLoading.value) {
            return const PopularRightNowShimmer();
          }

          //======================================================
          // EMPTY
          //======================================================

          if (popularController.topPopularItems.isEmpty) {
            return SizedBox(
              height: 120,
              width: double.infinity,
              child: Center(
                child: Text(
                  "No popular items yet.",
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
            padding: const EdgeInsets.only(left: 0),
            child: SizedBox(
              height: 170,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20),
                itemCount: popularController.topPopularItems.length,
                itemBuilder: (context, index) {
                  final item = popularController.topPopularItems[index];

                  return PopularItemCard(item: item);
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
