// ignore_for_file: non_constant_identifier_names, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';
import 'package:quick_bite/widgets/text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //============================================================
  // CONTROLLER
  //============================================================

  final UserController userController = Get.find<UserController>();

  //============================================================
  // TEXT CONTROLLERS
  //============================================================

  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  //============================================================
  // PASSWORD VISIBILITY
  //============================================================

  bool isCurrentPasswordVisible = false;

  bool isNewPasswordVisible = false;

  bool isConfirmPasswordVisible = false;

  //============================================================
  // LOADING
  //============================================================

  bool isLoading = false;

  //============================================================
  // DISPOSE
  //============================================================

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  //============================================================
  // CHANGE PASSWORD
  //============================================================

  Future<void> _changePassword() async {
    final String currentPassword = currentPasswordController.text.trim();

    final String newPassword = newPasswordController.text.trim();

    final String confirmPassword = confirmPasswordController.text.trim();

    //==========================================================
    // CURRENT PASSWORD VALIDATION
    //==========================================================

    if (currentPassword.isEmpty) {
      Snack_Bar.show(
        title: 'Current Password Required',
        message: 'Please enter your current password.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // NEW PASSWORD VALIDATION
    //==========================================================

    if (newPassword.isEmpty) {
      Snack_Bar.show(
        title: 'New Password Required',
        message: 'Please enter your new password.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // PASSWORD LENGTH
    //==========================================================

    if (newPassword.length < 6) {
      Snack_Bar.show(
        title: 'Weak Password',
        message: 'Your new password must contain at least 6 characters.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // CONFIRM PASSWORD
    //==========================================================

    if (confirmPassword.isEmpty) {
      Snack_Bar.show(
        title: 'Confirm Password',
        message: 'Please confirm your new password.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // PASSWORD MATCH
    //==========================================================

    if (newPassword != confirmPassword) {
      Snack_Bar.show(
        title: 'Password Mismatch',
        message: 'New password and confirm password do not match.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    //==========================================================
    // PREVENT SAME PASSWORD
    //==========================================================

    if (currentPassword == newPassword) {
      Snack_Bar.show(
        title: 'Same Password',
        message:
            'Your new password must be different from your current password.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      //==========================================================
      // FIREBASE USER
      //==========================================================

      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        throw Exception('No authenticated user found.');
      }

      //==========================================================
      // CHECK EMAIL/PASSWORD PROVIDER
      //==========================================================

      final bool hasPasswordProvider = firebaseUser.providerData.any(
        (provider) => provider.providerId == 'password',
      );

      if (!hasPasswordProvider) {
        Snack_Bar.show(
          title: 'Not Available',
          message:
              'Password change is only available for email/password accounts.',
          icon: FontAwesomeIcons.circleExclamation,
        );

        return;
      }

      //==========================================================
      // REAUTHENTICATE USER
      //==========================================================

      final AuthCredential credential = EmailAuthProvider.credential(
        email: firebaseUser.email!,
        password: currentPassword,
      );

      await firebaseUser.reauthenticateWithCredential(credential);

      //==========================================================
      // UPDATE PASSWORD
      //==========================================================

      await userController.changePassword(
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      //==========================================================
      // SUCCESS
      //==========================================================
      await userController.logout();
      if (!mounted) return;
      Get.offAllNamed(AppRoutes.methodSelection);

      Snack_Bar.show(
        title: 'Password Changed',
        message: 'Your password has been changed successfully.',
        icon: FontAwesomeIcons.solidCircleCheck,
      );

      //==========================================================
      // CLEAR FIELDS
      //==========================================================

      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

      //==========================================================
      // GO BACK
      //==========================================================

      Get.back();
    } on FirebaseAuthException catch (e) {
      //==========================================================
      // FIREBASE ERRORS
      //==========================================================

      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Your current password is incorrect.';
          break;

        case 'weak-password':
          message = 'Your new password is too weak.';
          break;

        case 'requires-recent-login':
          message = 'Please log in again before changing your password.';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection.';
          break;

        case 'too-many-requests':
          message = 'Too many attempts. Please try again later.';
          break;

        default:
          message = e.message ?? 'Unable to change your password.';
      }

      Snack_Bar.show(
        title: 'Password Change Failed',
        message: message,
        icon: FontAwesomeIcons.circleExclamation,
      );
    } catch (e) {
      //==========================================================
      // GENERAL ERROR
      //==========================================================

      Snack_Bar.show(
        title: 'Password Change Failed',
        message: e.toString(),
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //========================================================
      // BOTTOM BUTTON
      //========================================================
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: SizedBox(
            height: AppConstants.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : _changePassword,
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black,
                      ),
                    )
                  : Text('Change Password', style: AppTextTheme.titleText),
            ),
          ),
        ),
      ),

      //========================================================
      // BODY
      //========================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                const SizedBox(height: 20),

                //================================================
                // APP BAR
                //================================================
                AppBar(),

                const SizedBox(height: 35),

                //================================================
                // LOCK ICON
                //================================================
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.lock,
                      size: 50,
                      color: AppColors.primary
                    ),
                  ),
                ),

               
                const SizedBox(height: 35),

                //================================================
                // CURRENT PASSWORD
                //================================================
                CurrentPassword_TextField(),

                const SizedBox(height: 20),

                //================================================
                // NEW PASSWORD
                //================================================
                NewPassword_TextField(),

                const SizedBox(height: 20),

                //================================================
                // CONFIRM PASSWORD
                //================================================
                ConfirmPassword_TextField(),

                const SizedBox(height: 30),

                //================================================
                // PASSWORD REQUIREMENT
                //================================================
                PasswordRequirement(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBar() {
    return SafeArea(
      child: Row(
        children: [
          Back_Button(),

          const SizedBox(width: 15),

          Text('Change Password', style: AppTextTheme.appbarText),
        ],
      ),
    );
  }

  //============================================================
  // CURRENT PASSWORD FIELD
  //============================================================

  Widget CurrentPassword_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text('Current Password', style: AppTextTheme.textfieldtitleText),
          ],
        ),

        const SizedBox(height: 5),

        Text_Field(
          controller: currentPasswordController,
          hintText: 'Enter your current password',
          prefixIcon: FontAwesomeIcons.lock,
          obscureText: !isCurrentPasswordVisible,
          suffixIcon: isCurrentPasswordVisible
              ? FontAwesomeIcons.eyeSlash
              : FontAwesomeIcons.eye,
          onSuffixPressed: () {
            setState(() {
              isCurrentPasswordVisible = !isCurrentPasswordVisible;
            });
          },
        ),
      ],
    );
  }

  //============================================================
  // NEW PASSWORD FIELD
  //============================================================

  Widget NewPassword_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text('New Password', style: AppTextTheme.textfieldtitleText),
          ],
        ),

        const SizedBox(height: 5),

        Text_Field(
          controller: newPasswordController,
          hintText: 'Enter your new password',
          prefixIcon: FontAwesomeIcons.lock,
          obscureText: !isNewPasswordVisible,
          suffixIcon: isNewPasswordVisible
              ? FontAwesomeIcons.eyeSlash
              : FontAwesomeIcons.eye,
          onSuffixPressed: () {
            setState(() {
              isNewPasswordVisible = !isNewPasswordVisible;
            });
          },
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
            Text(
              'Confirm New Password',
              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),

        const SizedBox(height: 5),

        Text_Field(
          controller: confirmPasswordController,
          hintText: 'Re-enter your new password',
          prefixIcon: FontAwesomeIcons.lock,
          obscureText: !isConfirmPasswordVisible,
          suffixIcon: isConfirmPasswordVisible
              ? FontAwesomeIcons.eyeSlash
              : FontAwesomeIcons.eye,
          onSuffixPressed: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
        ),
      ],
    );
  }

  //============================================================
  // PASSWORD REQUIREMENT
  //============================================================

  Widget PasswordRequirement() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FaIcon(
            FontAwesomeIcons.circleInfo,
            size: 15,
            color: Colors.black,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Your password must contain at least 6 characters.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }
}
