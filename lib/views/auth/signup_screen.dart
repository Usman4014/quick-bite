// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/theme/App_Colors.dart';
import 'package:quick_bite/theme/App_TextTheme.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/text_field.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/shimmers/auth_logo_shimmer.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

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
        key: authController.signupFormKey,
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
                      // Important:
                      // Gives enough space at the bottom so the
                      // Login button doesn't cover the fields.
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 340),
                      child: Column(
                        children: [
                          WelcomingText(),
                          const SizedBox(height: 35),
                          Email_TextField(),
                          const SizedBox(height: 20),
                          Password_TextField(),
                          const SizedBox(height: 20),
                          ConfirmPassword_TextField(),
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
            Positioned(left: 20, right: 20, bottom: 20, child: Signup_Button()),
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
      padding: const EdgeInsets.only(
        top: 40,
        left: 30,
        right: 30,
      ),
      child: Obx(() {
        final String imageUrl =
            fixedAssetController.getImageUrl('app_logo');

        // Fixed asset is still loading
        if (imageUrl.isEmpty) {
          return const Center(
            child: AuthLogoShimmer(),
          );
        }

        return Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            // Network image is still loading
            return const Center(
              child: AuthLogoShimmer(),
            );
          },
          errorBuilder: (
            BuildContext context,
            Object error,
            StackTrace? stackTrace,
          ) {
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
          'Create New Account',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 1),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 37),
          child: Text(
            'Create your account & enjoy our delicious meals',
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
  // NAME FIELD
  //============================================================

  Widget Name_TextField() {
    return Column(
      children: [
        Row(
          children: [Text('Full Name', style: AppTextTheme.textfieldtitleText)],
        ),

        const SizedBox(height: 5),

        Text_Field(
          controller: authController.nameController,
          hintText: 'Enter your name',
          prefixIcon: FontAwesomeIcons.solidUser,
          keyboardType: TextInputType.name,
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
          controller: authController.signupEmailController,
          hintText: 'Enter your email',
          prefixIcon: FontAwesomeIcons.solidEnvelope,
          keyboardType: TextInputType.emailAddress,
        ),

        // AuthTextField(

        // ),
      ],
    );
  }

  //============================================================
  // PASSWORD FIELD
  //============================================================

  Widget Password_TextField() {
    return Column(
      children: [
        Row(
          children: [Text('Password', style: AppTextTheme.textfieldtitleText)],
        ),

        const SizedBox(height: 5),

        Obx(
          () => Text_Field(
            controller: authController.signupPasswordController,
            hintText: 'Create a password',
            prefixIcon: FontAwesomeIcons.lock,
            obscureText: !authController.isPasswordVisible.value,
            suffixIcon: authController.isPasswordVisible.value
                ? FontAwesomeIcons.eye
                : FontAwesomeIcons.eyeSlash,
            onSuffixPressed: authController.togglePasswordVisibility,
          ),
          // AuthTextField(

          // ),
        ),
      ],
    );
  }

  //============================================================
  // CONFIRM PASSWORD FIELD
  //============================================================

  Widget ConfirmPassword_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text('Confirm Password', style: AppTextTheme.textfieldtitleText),
          ],
        ),

        const SizedBox(height: 5),

        Obx(
          () => Text_Field(
            controller: authController.signupConfirmPasswordController,
            hintText: 'Create a password',
            prefixIcon: FontAwesomeIcons.lock,
            obscureText: !authController.isConfirmPasswordVisible.value,
            suffixIcon: authController.isConfirmPasswordVisible.value
                ? FontAwesomeIcons.eye
                : FontAwesomeIcons.eyeSlash,
            onSuffixPressed: authController.toggleConfirmPasswordVisibility,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != authController.signupPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          // AuthTextField(

          // ),
        ),
      ],
    );
  }

  //============================================================
  // SIGN UP BUTTON
  //============================================================

  Widget Signup_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isEmailLoading.value
              ? null
              : () {
                  authController.signUpWithEmail();
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
              : Text("Create Account", style: AppTextTheme.button),
        ),
      ),
    );
  }
}
