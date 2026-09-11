// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

import 'package:pinput/pinput.dart';
import 'package:quick_bite/widgets/back_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final AuthController authController = Get.find<AuthController>();

  @override
  void dispose() {
    authController.otpController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = Get.width;
    return Scaffold(
      backgroundColor: AppColors.primary,
      resizeToAvoidBottomInset: false,
      body: Stack(
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
                        Otp_TextField(),
                        const SizedBox(height: 20),
                        Resend_Otp(),
                        const SizedBox(height: 20),
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
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: VerifyOTP_Button(),
          ),
        ],
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
        child: Image.asset('assets/Logo1.png'),
      ),
    );
  }

  //============================================================
  Widget WelcomingText() {
    return Column(
      children: [
        Text(
          'Verify Your Number',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 1),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Obx(() {
            final String phoneNumber =
                authController.requestedPhoneNumber.value;

            return Text(
              phoneNumber.isEmpty
                  ? 'Enter the verification code sent to your phone'
                  : 'Enter the verification code sent to\n$phoneNumber',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyText,
            );
          }),
        ),
      ],
    );
  }

  //============================================================
  Widget Otp_TextField() {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 58,
      textStyle: AppTextTheme.appbarText,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
    );

    return Column(
      children: [
        Row(
          children: [
            Text('Verification Code', style: AppTextTheme.textfieldtitleText),
          ],
        ),

        const SizedBox(height: 12),

        Pinput(
          controller: authController.otpController,

          //======================================================
          // 6 DIGITS
          //======================================================
          length: 6,

          //======================================================
          // ONLY NUMBERS
          //======================================================
          keyboardType: TextInputType.number,

          //======================================================
          // MOVE TO NEXT FIELD AUTOMATICALLY
          //======================================================
          textInputAction: TextInputAction.done,

          //======================================================
          // PIN THEMES
          //======================================================
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,

          //======================================================
          // VALIDATION
          //======================================================
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the OTP';
            }

            if (value.length != 6) {
              return 'OTP must be 6 digits';
            }

            return null;
          },

          //======================================================
          // WHEN 6 DIGITS ARE ENTERED
          //======================================================
          onCompleted: (pin) {
            debugPrint('OTP entered: $pin');
          },
        ),
      ],
    );
  }

  //============================================================
  Widget Resend_Otp() {
    return Obx(() {
      final bool canResend = authController.canResendOTP;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Didn\'t receive the code?', style: AppTextTheme.bodyText),

          const SizedBox(width: 8),

          InkWell(
            onTap: canResend
                ? () {
                    authController.resendPhoneOTP();
                  }
                : null,
            child: Text(
              canResend
                  ? 'Resend OTP'
                  : 'Resend in ${authController.resendSeconds}s',
              style: canResend ? AppTextTheme.textButton : AppTextTheme.caption,
            ),
          ),
        ],
      );
    });
  }

  //============================================================
  Widget VerifyOTP_Button() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: AppConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: authController.isVerifyOTPLoading.value
              ? null
              : () {
                  authController.verifyPhoneOTP();
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.white,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: authController.isVerifyOTPLoading.value
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
              : Text('Verify OTP', style: AppTextTheme.button),
        ),
      ),
    );
  }

  
}
