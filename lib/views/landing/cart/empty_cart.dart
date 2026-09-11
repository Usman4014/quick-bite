// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class EmptyCart extends StatefulWidget {
  const EmptyCart({super.key});

  @override
  State<EmptyCart> createState() => _EmptyCartState();
}

class _EmptyCartState extends State<EmptyCart> {
  final LandingController landingController =
      Get.find<LandingController>();

  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();

  //============================================================
  // IMAGE LOADING STATE
  //============================================================

  String? _loadingUrl;
  bool _imageLoaded = false;

  @override
  Widget build(BuildContext context) {
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
            // EMPTY CART IMAGE
            //==================================================

            Obx(() {
              final String imageUrl =
                  fixedAssetController.getImageUrl(
                'empty_no_cart',
              );

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
              // IMAGE STILL LOADING
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
            // TITLE
            //==================================================

            Text(
              "Your Cart is Empty",
              style: AppTextTheme.appbarText,
            ),

            const SizedBox(height: 2),

            //==================================================
            // DESCRIPTION
            //==================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: Text(
                "Looks like you haven't added any delicious food "
                "to your cart yet.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 35),

            //==================================================
            // CONTINUE SHOPPING
            //==================================================

            SizedBox(
              width: double.infinity,
              height: AppConstants.buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  landingController.changeTab(0);
                },
                child: Text(
                  "Continue Shopping",
                  style: AppTextTheme.titleText,
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
          height: 110,
          width: 110,
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,

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

            errorBuilder: (
              context,
              error,
              stackTrace,
            ) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted &&
                    _loadingUrl == imageUrl) {
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
  // FINAL IMAGE CONTAINER
  //============================================================

  Widget _imageContainer(String imageUrl) {
    return Container(
      height: 110,
      width: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(
          alpha: 0.1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: ClipOval(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Icon(
              Icons.shopping_cart_outlined,
              size: 55,
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
        height: 110,
        width: 110,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}