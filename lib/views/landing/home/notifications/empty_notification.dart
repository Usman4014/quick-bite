// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class EmptyNotification extends StatelessWidget {
  const EmptyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final FixedAssetController fixedAssetController =
        Get.find<FixedAssetController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 130,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //==================================================
            // EMPTY NOTIFICATION IMAGE
            //==================================================

            Obx(() {
              final String imageUrl =
                  fixedAssetController.getImageUrl(
                'empty_notification',
              );

              return Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(
                    alpha: 0.1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: imageUrl.isEmpty
                      ? Icon(
                          Icons.notifications_none_outlined,
                          size: 55,
                          color: AppColors.primary,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Icon(
                              Icons.notifications_none_outlined,
                              size: 55,
                              color: AppColors.primary,
                            );
                          },
                        ),
                ),
              );
            }),

            const SizedBox(height: 15),

            //==================================================
            // TITLE
            //==================================================

            Text(
              "No Notifications Yet",
              style: AppTextTheme.appbarText,
            ),

            //==================================================
            // DESCRIPTION
            //==================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Text(
                "We will notify you about orders, offers and special deals",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}