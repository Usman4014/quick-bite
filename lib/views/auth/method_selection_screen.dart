// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_Colors.dart';
import 'package:quick_bite/theme/App_TextTheme.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/widgets/snack_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/shimmers/auth_logo_shimmer.dart';

class MethodSelectionScreen extends StatelessWidget {
  MethodSelectionScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();

  @override
  Widget build(BuildContext context) {
    final double height = Get.height;
    final double width = Get.width;
    return Scaffold(
      backgroundColor: AppColors.primary,

      body: Column(
        children: [
          Image_Container(),
          Container(
            width: width,
            height: height * 0.7,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 25),

                  //================================================
                  // WELCOME TEXT
                  //================================================
                  WelcomingText(),

                  const SizedBox(height: 35),

                  //================================================
                  // PHONE LOGIN
                  //================================================
                  PhoneLogin_Button(),

                  const SizedBox(height: 15),

                  //================================================
                  // EMAIL LOGIN
                  //================================================
                  EmailLogin_Button(),

                  const SizedBox(height: 15),

                  //================================================
                  // GOOGLE LOGIN LOGIN
                  //================================================
                  GoogleLogin_Button(),

                  const SizedBox(height: 15),

                  //================================================
                  // FACEBOOK LOGIN
                  //================================================
                  FacebookLogin_Button(),

                  const SizedBox(height: 25),

                  NewToQuickBite_Text(),

                  const SizedBox(height: 25),

                  //================================================
                  // SIGN UP
                  //================================================
                  SignUp_Button(),
                  const Spacer(),
                  Safety_Text(),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: Stack(children: [Background_Logo(), Front_Deatiled_Part()]),
    );
  }

  //============================================================
  // IMAGE CONTAINER
  //============================================================

  Widget Image_Container() {
    final double height = Get.height;
    final double width = Get.width;

    return SizedBox(
      width: width,
      height: height * 0.3,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
        child: Obx(() {
          final String imageUrl = fixedAssetController.getImageUrl('app_logo');

          if (imageUrl.isEmpty) {
            return const Center(child: AuthLogoShimmer());
          }

          return Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }

              return const Center(child: AuthLogoShimmer());
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported_outlined, size: 70);
            },
          );
        }),
      ),
    );
  }

  //============================================================
  // WELCOME TEXT
  //============================================================

  Widget WelcomingText() {
    return Column(
      children: [
        Text(
          'Welcome!',
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 1),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'Choose a login method to continue',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  //============================================================
  // PHONE LOGIN BUTTON
  //============================================================

  Widget PhoneLogin_Button() {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(AppRoutes.phoneLogin);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(FontAwesomeIcons.phone, size: 18),

            const SizedBox(width: 12),

            Text('Continue with Phone', style: AppTextTheme.titleText),
          ],
        ),
      ),
    );
  }

  //============================================================
  // EMAIL LOGIN BUTTON
  //============================================================

  Widget EmailLogin_Button() {
    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(AppRoutes.emailLogin);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.solidEnvelope,
              size: 18,
              color: Colors.black,
            ),

            const SizedBox(width: 12),

            Text('Continue with Email', style: AppTextTheme.titleText),
          ],
        ),
      ),
    );
  }

  //============================================================
  // GOOGLE LOGIN BUTTON
  //============================================================

  Widget GoogleLogin_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isGoogleLoading.value
              ? null
              : () {
                  authController.loginWithGoogle();
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: authController.isGoogleLoading.value
              ? const SizedBox(
                  width: 60,
                  height: 24,
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.google,
                      size: 18,
                      color: Colors.black,
                    ),

                    const SizedBox(width: 12),

                    Text('Continue with Google', style: AppTextTheme.titleText),
                  ],
                ),
        ),
      ),
    );
  }

  //============================================================
  // FACEBOOK LOGIN BUTTON
  //============================================================

  Widget FacebookLogin_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isFacebookLoading.value
              ? null
              : () async {
                  try {
                    await authController.loginWithFacebook();
                  } catch (e) {
                    Snack_Bar.show(
                      title: "Facebook Login Failed",
                      message: e.toString(),
                      icon: FontAwesomeIcons.facebook,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: authController.isFacebookLoading.value
              ? const SizedBox(
                  width: 60,
                  height: 24,
                  child: Center(
                    child: SpinKitThreeBounce(
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 18,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Continue with Facebook',
                      style: AppTextTheme.titleText,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
  //============================================================
  // NEW TO QUICK BITE TEXT
  //============================================================

  Widget NewToQuickBite_Text() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),

        const SizedBox(width: 10),

        Text('New to Quick Bite?', style: AppTextTheme.caption),

        const SizedBox(width: 10),

        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
      ],
    );
  }

  //============================================================
  // SIGN UP
  //============================================================

  Widget SignUp_Button() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.signup);
      },
      child: Container(
        height: 55,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.primary, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.userPlus,
              color: AppColors.primary,
              size: 18,
            ),
            SizedBox(width: 10),
            Text('Create New Account', style: AppTextTheme.titleText),
          ],
        ),
      ),
    );
  }

  //============================================================
  // SAFETY TEXT
  //============================================================
  Widget Safety_Text() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          FontAwesomeIcons.shieldHalved,
          color: AppColors.primary,
          size: 14,
        ),
        SizedBox(width: 10),
        Text(
          'Your data is safe and secure with us',
          style: AppTextTheme.caption,
        ),
      ],
    );
  }
}
