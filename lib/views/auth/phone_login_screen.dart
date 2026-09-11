// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final AuthController authController = Get.find<AuthController>();

  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();
  @override
  void dispose() {
    authController.phoneController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = Get.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primary,
      body: Form(
        key: authController.phoneFormKey,
        child: Stack(
          children: [
            Column(
              children: [
                Image_Container(),
                Expanded(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
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
                          const SizedBox(height: 25),
                          WelcomingText(),
                          const SizedBox(height: 35),
                          Phone_TextField(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: SendOTP_Button(),
            ),
            Positioned(left: 20, right: 20, top: 10, child: App_Bar()),
          ],
        ),
      ),
    );
  }

  //============================================================
  Widget App_Bar() {
    return SafeArea(child: Row(children: [Back_Button()]));
  }

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
  Widget WelcomingText() {
    return Column(
      children: [
        Text(
          'Login with Phone',
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
            'We will send you a verification code',
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
  Widget Phone_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text('Phone Number', style: AppTextTheme.textfieldtitleText),
          ],
        ),

        const SizedBox(height: 5),

        Text_Field(
          controller: authController.phoneController,

          // Shows +1 but does NOT put +1 inside the controller
          prefixText: '+1 ',

          // Maximum 10 digits
          maxlength: 10,

          hintText: 'Enter 10-digit US phone number',

          prefixIcon: FontAwesomeIcons.phone,

          keyboardType: TextInputType.number,

          textInputAction: TextInputAction.done,

          //========================================================
          // ONLY NUMBERS + MAXIMUM 10 DIGITS
          //========================================================
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],

          //========================================================
          // VALIDATION
          //========================================================
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your phone number';
            }

            if (value.length != 10) {
              return 'Please enter a valid 10-digit US phone number';
            }

            return null;
          },
        ),
      ],
    );
  }

  //============================================================
  Widget SendOTP_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isSendOTPLoading.value
              ? null
              : () {
                  if (authController.phoneFormKey.currentState!.validate()) {
                    authController.sendPhoneOTP();
                  }
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: authController.isSendOTPLoading.value
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
              : Text('Send OTP', style: AppTextTheme.button),
        ),
      ),
    );
  }
}
