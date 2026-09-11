// ignore_for_file: file_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/Offer_Controller.dart';
import 'package:quick_bite/enums/Offer_Discount_Type.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_Colors.dart';

class FeaturedOfferBanner extends StatefulWidget {
  const FeaturedOfferBanner({super.key});

  @override
  State<FeaturedOfferBanner> createState() => _FeaturedOfferBannerState();
}

class _FeaturedOfferBannerState extends State<FeaturedOfferBanner> {
  final OfferController offerController = Get.find<OfferController>();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final featuredOffers = offerController.featuredOffers;

      if (featuredOffers.isEmpty) {
        return const SizedBox.shrink();
      }

      // Prevent index from becoming invalid
      // if the number of featured offers changes.
      if (currentIndex >= featuredOffers.length) {
        currentIndex = 0;
      }

      return Column(
        children: [
          CarouselSlider.builder(
            itemCount: featuredOffers.length,

            itemBuilder: (context, index, realIndex) {
              final offer = featuredOffers[index];

              return GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.offerDetails, arguments: offer);
                },

                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),

                    child: Stack(
                      fit: StackFit.expand,

                      children: [
                        //=========================================
                        // CLOUDINARY BANNER IMAGE
                        //=========================================

                        Image.network(
                          offer.bannerImage,

                          fit: BoxFit.cover,

                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },

                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,

                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 45,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),

                        //=========================================
                        // GRADIENT
                        //=========================================
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,

                              colors: [
                                Colors.black87,
                                Colors.black26,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        //=========================================
                        // DISCOUNT BADGE
                        //=========================================
                        Positioned(
                          top: 16,
                          left: 16,

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),

                            child: Text(
                              offer.discountType == OfferDiscountType.percentage
                                  ? "${offer.discountValue.toInt()}% OFF"
                                  : "\$${offer.discountValue.toInt()} OFF",

                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        //=========================================
                        // OFFER DETAILS
                        //=========================================
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                offer.title,

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                offer.description,

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },

            options: CarouselOptions(
              height: 200,

              viewportFraction: 1,

              autoPlay: true,

              enlargeCenterPage: true,

              autoPlayInterval: const Duration(seconds: 4),

              onPageChanged: (index, reason) {
                if (mounted) {
                  setState(() {
                    currentIndex = index;
                  });
                }
              },
            ),
          ),

          const SizedBox(height: 12),

          //=========================================
          // INDICATOR
          //=========================================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(featuredOffers.length, (index) {
              final selected = currentIndex == index;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),

                margin: const EdgeInsets.symmetric(horizontal: 4),

                height: 8,

                width: selected ? 22 : 8,

                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.grey.shade400,

                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
        ],
      );
    });
  }
}
