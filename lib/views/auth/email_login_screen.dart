// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_Colors.dart';
import 'package:quick_bite/theme/App_TextTheme.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/text_field.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/shimmers/auth_logo_shimmer.dart';

class EmailLoginScreen extends StatelessWidget {
  EmailLoginScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();

  @override
  Widget build(BuildContext context) {
    final double width = Get.width;

    return Scaffold(
      backgroundColor: AppColors.primary,

      //============================================================
      // IMPORTANT:
      // Keyboard will NOT resize the Scaffold.
      // Login button will stay fixed.
      //============================================================
      resizeToAvoidBottomInset: false,

      body: Form(
        key: authController.loginFormKey,
        child: Stack(
          children: [
            //========================================================
            // MAIN CONTENT
            //========================================================
            Column(
              children: [
                //====================================================
                // LOGO
                //====================================================
                Image_Container(),

                //====================================================
                // WHITE CONTENT AREA
                //====================================================
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
                      physics: const BouncingScrollPhysics(),

                      // Important:
                      // Gives enough space at the bottom so the
                      // Login button doesn't cover the fields.
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 120),

                      child: Column(
                        children: [
                          //================================================
                          // WELCOME TEXT
                          //================================================
                          WelcomingText(),

                          const SizedBox(height: 35),

                          //================================================
                          // EMAIL
                          //================================================
                          Email_TextField(),

                          const SizedBox(height: 20),

                          //================================================
                          // PASSWORD
                          //================================================
                          Password_TextField(),

                          const SizedBox(height: 10),

                          //================================================
                          // FORGOT PASSWORD
                          //================================================
                          ForgotPassword_Button(),

                          // Extra space for comfortable scrolling
                          const SizedBox(height: 30),
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
            Positioned(left: 20, right: 20, bottom: 20, child: Login_Button()),
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

          // Firebase/Firestore asset still loading
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

                  // Cloudinary image still loading
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
          'Login with Email',
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
            'Enter your Email and Password to continue',
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
  // EMAIL TEXT FIELD
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
          controller: authController.loginEmailController,
          hintText: 'Enter your email',
          prefixIcon: FontAwesomeIcons.solidEnvelope,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
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
  // PASSWORD TEXT FIELD
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
            controller: authController.loginPasswordController,
            hintText: 'Enter your password',
            prefixIcon: FontAwesomeIcons.lock,
            obscureText: !authController.isPasswordVisible.value,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            suffixIcon: authController.isPasswordVisible.value
                ? FontAwesomeIcons.eye
                : FontAwesomeIcons.eyeSlash,
            onSuffixPressed: authController.togglePasswordVisibility,
          ),
        ),
      ],
    );
  }

  //============================================================
  // FORGOT PASSWORD
  //============================================================

  Widget ForgotPassword_Button() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.forgotpassword);
        },
        child: Text('Forgot Password?', style: AppTextTheme.textButton),
      ),
    );
  }

  //============================================================
  // LOGIN BUTTON
  //============================================================

  Widget Login_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isEmailLoading.value
              ? null
              : () {
                  if (authController.loginFormKey.currentState!.validate()) {
                    authController.loginWithEmail();
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
              : Text("Login", style: AppTextTheme.button),
        ),
      ),
    );
  }
}
