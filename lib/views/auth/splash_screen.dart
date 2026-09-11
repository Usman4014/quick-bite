import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //============================================================
  // CONTROLLER
  //============================================================

  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    _startSplash();
  }

  //============================================================
  // START SPLASH
  //============================================================

  Future<void> _startSplash() async {
    // Keep splash visible for at least 2 seconds.
    await Future.delayed(
      const Duration(seconds: 4),
    );

    if (!mounted) return;

    Get.offNamed(AppRoutes.banner);
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          final String imageUrl =
              fixedAssetController.getImageUrl('app_logo');

          //======================================================
          // LOGO LOADING
          //======================================================

          if (imageUrl.isEmpty) {
            return const SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary,),
              ),
            );
          }

          //======================================================
          // LOGO
          //======================================================

          return Image.network(
            imageUrl,
            width: 130,
            height: 130,
            fit: BoxFit.contain,
            cacheWidth: 360,
            cacheHeight: 360,
            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              return const Icon(
                Icons.fastfood,
                size: 80,
              );
            },
          );
        }),
      ),
    );
  }
}