// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/shimmers/auth_logo_shimmer.dart';
import 'package:quick_bite/widgets/text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final AuthController authController = Get.find<AuthController>();
  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();

  @override
  Widget build(BuildContext context) {
    final double width = Get.width;
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: Form(
        key: authController.resetPasswordFormKey,
        child: Stack(
          children: [
            Column(
              children: [
                Image_Container(),
                Expanded(
                  child: Container(
                    width: width,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 120),

                      child: Column(
                        children: [
                          WelcomingText(),
                          const SizedBox(height: 35),
                          Email_TextField(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //========================================================
            // BACK BUTTON
            //========================================================
            Positioned(left: 20, right: 20, top: 10, child: App_Bar()),

            //========================================================
            // FIXED LOGIN BUTTON
            //========================================================
            Positioned(left: 20, right: 20, bottom: 20, child: Reset_Button()),
          ],
        ),
      ),
    );
  }

  //============================================================
  // APP BAR / BACK BUTTON
  //============================================================

  Widget App_Bar() {
    return SafeArea(child: Row(children: [Back_Button()]));
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

          // Fixed asset is still loading
          if (imageUrl.isEmpty) {
            return const Center(child: AuthLogoShimmer());
          }

          return Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder:
                (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  // Network image is still loading
                  return const Center(child: AuthLogoShimmer());
                },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
                  return const Icon(
                    Icons.image_not_supported_outlined,
                    size: 70,
                  );
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
          'Forgot Password?',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 1),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            'We will send you a reset link to your given email',
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
  // EMAIL FIELD
  //============================================================

  Widget Email_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text('Email Address', style: AppTextTheme.textfieldtitleText),
          ],
        ),

        const SizedBox(height: 5),
        Text_Field(
          controller: authController.resetEmailController,
          hintText: 'Enter your email',
          prefixIcon: FontAwesomeIcons.solidEnvelope,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }

            if (!GetUtils.isEmail(value.trim())) {
              return 'Please enter a valid email';
            }

            return null;
          },
        ),
      ],
    );
  }

  //============================================================
  // RESET BUTTON
  //============================================================

  Widget Reset_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isEmailLoading.value
              ? null
              : () {
                  if (authController.resetPasswordFormKey.currentState!
                      .validate()) {
                    authController.sendPasswordResetEmail();
                  }
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: authController.isEmailLoading.value
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
              : Text('Send Reset Link', style: AppTextTheme.titleText),
        ),
      ),
    );
  }
}
