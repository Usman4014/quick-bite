// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/helpers/cloudinary_image_helper.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/shimmers/home_banner_shimmer.dart';
import 'package:quick_bite/theme/app_colors.dart';

class SpecialDealsBanner extends StatefulWidget {
  const SpecialDealsBanner({super.key});

  @override
  State<SpecialDealsBanner> createState() => _SpecialDealsBannerState();
}

class _SpecialDealsBannerState extends State<SpecialDealsBanner> {
  final controller = Get.find<SpecialDealsController>();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //==========================================================
      // LOADING
      //==========================================================

      if (controller.isLoading.value) {
        return const HomeBannerShimmer();
      }

      //==========================================================
      // ERROR
      //==========================================================

      if (controller.errorMessage.value.isNotEmpty) {
        return const SizedBox.shrink();
      }

      //==========================================================
      // FEATURED DEALS
      //==========================================================

      final featuredDeals = controller.specialDeals
          .where((deal) => deal.isFeatured)
          .take(5)
          .toList();

      //==========================================================
      // NO FEATURED DEALS
      //==========================================================

      if (featuredDeals.isEmpty) {
        return const SizedBox.shrink();
      }

      // Prevent invalid indicator index after data changes.
      if (currentIndex >= featuredDeals.length) {
        currentIndex = 0;
      }

      //==========================================================
      // REAL BANNER
      //==========================================================

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              //==================================================
              // CAROUSEL
              //==================================================

              CarouselSlider.builder(
                itemCount: featuredDeals.length,
                options: CarouselOptions(
                  autoPlayInterval: const Duration(seconds: 2),
                  viewportFraction: 1,
                  height: 200,
                  autoPlay: featuredDeals.length > 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    if (!mounted) return;

                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.specialDealDetails,
                        arguments: featuredDeals[index],
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          CloudinaryImageHelper.optimize(
                            featuredDeals[index].bannerImage,
                            width: 800,
                            height: 400,
                          ),
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
                    ),
                  );
                },
              ),

              //==================================================
              // PAGE INDICATORS
              //==================================================
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 20,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                    color: Color.fromRGBO(158, 158, 158, 0.7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      featuredDeals.length,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
