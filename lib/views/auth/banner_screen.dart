// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/Banner_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  //============================================================
  // CONTROLLER
  //============================================================

  final BannerController controller = Get.find<BannerController>();

  //============================================================
  // CURRENT INDEX
  //============================================================

  int currentIndex = 0;

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: GetStarted_Button(),

      body: Obx(() {
        //============================================================
        // BANNERS ARE LOADING
        //============================================================

        if (controller.isLoading.value && controller.banners.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }

        //============================================================
        // NO BANNERS
        //============================================================

        if (controller.banners.isEmpty) {
          return const Center(child: Text('No banners available.'));
        }

        //============================================================
        // BANNERS AVAILABLE
        //============================================================

        return Column(
          children: [
            Carousel_Slider(),

            const SizedBox(height: 10),

            Banner_Indicators(),
          ],
        );
      }),
    );
  }

  //============================================================
  // GET STARTED BUTTON
  //============================================================

  Widget GetStarted_Button() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: () {
            Get.offNamed(AppRoutes.methodSelection);
          },
          child: Text("Get Started", style: AppTextTheme.button),
        ),
      ),
    );
  }

  //============================================================
  // CAROUSEL SLIDER
  //============================================================

  Widget Carousel_Slider() {
    final double height = MediaQuery.of(context).size.height;

    final int bannerCount = controller.banners.length;

    return CarouselSlider.builder(
      itemCount: bannerCount,

      itemBuilder: (context, index, realIndex) {
        final banner = controller.banners[index];

        return ClipRRect(
          child: Image.network(
            optimizedBannerUrl(banner.image),
            width: double.infinity,
            fit: BoxFit.cover,

            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        );
      },

      options: CarouselOptions(
        height: height * 0.85,

        //========================================================
        // ONLY AUTOPLAY WHEN THERE ARE MULTIPLE BANNERS
        //========================================================
        autoPlay: bannerCount > 1,

        autoPlayInterval: const Duration(seconds: 4),

        viewportFraction: 1,

        //========================================================
        // DISABLE INFINITE SCROLL FOR ONE BANNER
        //========================================================
        enableInfiniteScroll: bannerCount > 1,

        onPageChanged: (index, reason) {
          if (!mounted) return;

          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  //============================================================
  // BANNER INDICATORS
  //============================================================

  Widget Banner_Indicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(
        controller.banners.length,

        (index) => AnimatedContainer(
          width: currentIndex == index ? 20 : 8,

          height: 8,

          duration: const Duration(milliseconds: 300),

          margin: const EdgeInsets.symmetric(horizontal: 4),

          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppColors.primary
                : Colors.grey.shade400,

            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  String optimizedBannerUrl(String url) {
    if (!url.contains('/upload/')) {
      return url;
    }

    return url.replaceFirst('/upload/', '/upload/f_auto,q_auto,w_1080/');
  }
}
