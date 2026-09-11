// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_bite/helpers/cloudinary_image_helper.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class SpecialDealsCard extends StatelessWidget {
  final SpecialDealsModel deal;

  const SpecialDealsCard({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      onTap: () {
        Get.toNamed(AppRoutes.specialDealDetails, arguments: deal);
      },
      child: Container(
        height: 190,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                CloudinaryImageHelper.optimize(
                  deal.bannerImage,
                  width: 800,
                  height: 400,
                ),
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
                cacheWidth: 800,
                cacheHeight: 400,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 190,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.0),

                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,

              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5,
                    ),
                    child: Text('Add', style: AppTextTheme.button),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
