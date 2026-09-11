// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/aboutquickbite/contact_tile.dart';
import 'package:quick_bite/views/profile/aboutquickbite/info_card.dart';
import 'package:quick_bite/views/profile/paymentmethods/feature_tile.dart';
import 'package:quick_bite/widgets/back_button.dart';

class AboutQuickBiteScreen extends StatefulWidget {
  const AboutQuickBiteScreen({super.key});

  @override
  State<AboutQuickBiteScreen> createState() => _AboutQuickBiteScreenState();
}

class _AboutQuickBiteScreenState extends State<AboutQuickBiteScreen> {
  String? _loadingUrl;
  bool _imageLoaded = false;

  @override
  Widget build(BuildContext context) {
    final FixedAssetController fixedAssetController =
        Get.find<FixedAssetController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Row(
              children: [
                AppBar(),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    //==================================================
                    // LOGO
                    //==================================================

                    Obx(() {
                      final String imageUrl =
                          fixedAssetController.getImageUrl('app_logo');

                      //================================================
                      // NO IMAGE URL YET
                      //================================================

                      if (imageUrl.isEmpty) {
                        return _imageShimmer();
                      }

                      //================================================
                      // NEW IMAGE URL
                      //================================================

                      if (_loadingUrl != imageUrl) {
                        _loadingUrl = imageUrl;
                        _imageLoaded = false;
                      }

                      //================================================
                      // IMAGE LOADING
                      //================================================

                      if (!_imageLoaded) {
                        return _imageLoadingWidget(imageUrl);
                      }

                      //================================================
                      // IMAGE LOADED
                      //================================================

                      return _imageContainer(imageUrl);
                    }),

                    const SizedBox(height: 15),

                    //==================================================
                    // APP NAME
                    //==================================================

                    Text(
                      "Quick Bite",
                      style: AppTextTheme.appbarText,
                    ),

                    const SizedBox(height: 5),

                    //==================================================
                    // TAGLINE
                    //==================================================

                    Text(
                      "Fast, Fresh & Delicious",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //==================================================
                    // VERSION
                    //==================================================

                    InfoCard(
                      title: "Version",
                      icon: FontAwesomeIcons.mobileScreen,
                      child: Text(
                        "1.0.0",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    //==================================================
                    // ABOUT
                    //==================================================

                    InfoCard(
                      title: "About",
                      icon: FontAwesomeIcons.circleInfo,
                      child: Text(
                        "Quick Bite is your trusted food ordering companion. "
                        "Browse delicious meals, customize your order, save favorites, "
                        "and enjoy fast doorstep delivery with a smooth and secure experience.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    //==================================================
                    // FEATURES
                    //==================================================

                    InfoCard(
                      title: "Features",
                      icon: FontAwesomeIcons.solidStar,
                      child: Column(
                        children: const [
                          FeatureTile(
                            text: "Browse Delicious Meals",
                          ),
                          FeatureTile(
                            text: "Quick & Easy Ordering",
                          ),
                          FeatureTile(
                            text: "Secure Payment Methods",
                          ),
                          FeatureTile(
                            text: "Save Favorite Foods",
                          ),
                          FeatureTile(
                            text: "Track Your Orders",
                          ),
                          FeatureTile(
                            text: "Ratings & Reviews",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    //==================================================
                    // CONTACT
                    //==================================================

                    InfoCard(
                      title: "Contact",
                      icon: FontAwesomeIcons.headset,
                      child: Column(
                        children: [
                          ContactTile(
                            icon: FontAwesomeIcons.envelope,
                            text: "support@quickbite.com",
                          ),
                          const SizedBox(height: 12),
                          ContactTile(
                            icon: FontAwesomeIcons.globe,
                            text: "www.quickbite.com",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    //==================================================
                    // COPYRIGHT
                    //==================================================

                    Text(
                      "© 2026 Quick Bite",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Made with ❤️",
                      style: GoogleFonts.poppins(
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // IMAGE WHILE LOADING
  //============================================================

  Widget _imageLoadingWidget(String imageUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        //========================================================
        // LOAD ACTUAL IMAGE IN BACKGROUND
        //========================================================

        SizedBox(
          height: 100,
          width: 100,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,

            //======================================================
            // IMAGE FINISHED LOADING
            //======================================================

            frameBuilder: (
              BuildContext context,
              Widget child,
              int? frame,
              bool wasSynchronouslyLoaded,
            ) {
              if (wasSynchronouslyLoaded || frame != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted &&
                      _loadingUrl == imageUrl &&
                      !_imageLoaded) {
                    setState(() {
                      _imageLoaded = true;
                    });
                  }
                });
              }

              return Opacity(
                opacity: 0,
                child: child,
              );
            },

            //======================================================
            // IMAGE ERROR
            //======================================================

            errorBuilder: (context, error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && _loadingUrl == imageUrl) {
                  setState(() {
                    _imageLoaded = true;
                  });
                }
              });

              return const SizedBox();
            },
          ),
        ),

        //========================================================
        // SHIMMER
        //========================================================

        _imageShimmer(),
      ],
    );
  }

  //============================================================
  // FINAL IMAGE
  //============================================================

  Widget _imageContainer(String imageUrl) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.image_not_supported_outlined,
              size: 45,
              color: AppColors.primary,
            );
          },
        ),
      ),
    );
  }

  //============================================================
  // IMAGE SHIMMER
  //============================================================

  Widget _imageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),
            const SizedBox(width: 15),
            Text(
              "About Quick Bite",
              style: AppTextTheme.appbarText,
            ),
          ],
        ),
      ),
    );
  }
}