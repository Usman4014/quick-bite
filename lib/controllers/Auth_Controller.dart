// ignore_for_file: file_names

import 'dart:async';
import 'package:quick_bite/services/FCM_Service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/services/Auth_Service.dart';
import 'package:quick_bite/services/User_Service.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final FCMService _fcmService = FCMService();

  late final UserController userController;

  final TextEditingController nameController = TextEditingController();

  final TextEditingController loginEmailController = TextEditingController();

  final TextEditingController signupEmailController = TextEditingController();

  final TextEditingController resetEmailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController loginPasswordController = TextEditingController();

  final TextEditingController signupPasswordController =
      TextEditingController();

  final TextEditingController signupConfirmPasswordController =
      TextEditingController();

  final TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> phoneFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> resetPasswordFormKey = GlobalKey<FormState>();

  final RxInt resendSeconds = 0.obs;

  Timer? _resendTimer;

  int? _resendToken;

  final RxString verificationId = ''.obs;

  final RxBool isSendOTPLoading = false.obs;
  final RxBool isVerifyOTPLoading = false.obs;
  final RxBool isEmailLoading = false.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isFacebookLoading = false.obs;

  final RxBool isLogoutLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final RxBool isConfirmPasswordVisible = false.obs;

  final RxString requestedPhoneNumber = ''.obs;

  bool get canResendOTP {
    return resendSeconds.value == 0;
  }

  Stream<User?> get authState {
    return _authService.authStateChanges;
  }

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<UserController>()) {
      userController = Get.find<UserController>();
    } else {
      userController = Get.put(UserController());
    }

    _initializeGoogleSignIn();
  }

  //============================================================
  //============================================================
  //============================================================
  // EMAIL LOGIN
  //============================================================
  //============================================================
  //============================================================

  Future<void> loginWithEmail() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) {
      return;
    }

    try {
      isEmailLoading.value = true;

      final UserCredential credential = await _authService.loginWithEmail(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        Snack_Bar.show(
          title: "Login Failed",
          message: "Firebase did not return a user.",
          icon: FontAwesomeIcons.circleExclamation,
        );

        return;
      }

      await _handleSuccessfulAuthentication(firebaseUser);
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('Login error: $e');
      Snack_Bar.show(
        title: "Login Failed",
        message: "Something went wrong. Please try again.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isEmailLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // EMAIL SIGN UP
  //============================================================
  //============================================================
  //============================================================

  Future<void> signUpWithEmail() async {
    if (!(signupFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final String password = signupPasswordController.text.trim();
    final String confirmPassword = signupConfirmPasswordController.text.trim();

    if (password != confirmPassword) {
      Snack_Bar.show(
        title: "Password Mismatch",
        message: "Passwords do not match.",
        icon: FontAwesomeIcons.circleExclamation,
      );
      return;
    }

    try {
      isEmailLoading.value = true;

      //==========================================================
      // CREATE FIREBASE ACCOUNT
      //==========================================================

      final UserCredential credential = await _authService.signUpWithEmail(
        email: signupEmailController.text.trim(),
        password: password,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        Snack_Bar.show(
          title: "Signup Failed",
          message: "Firebase did not return a user.",
          icon: FontAwesomeIcons.circleExclamation,
        );
        return;
      }

      final String name = nameController.text.trim();
      final String phone = phoneController.text.trim();

      //==========================================================
      // UPDATE FIREBASE DISPLAY NAME
      //==========================================================

      await firebaseUser.updateDisplayName(name);

      //==========================================================
      // CREATE USER PROFILE
      //==========================================================

      await _userService.createUser(
        firebaseUser: firebaseUser,
        name: name,
        phoneNumber: phone,
        profileImage: firebaseUser.photoURL,
      );

      //==========================================================
      // LOAD USER LOCALLY
      //==========================================================

      await userController.loadUser(firebaseUser.uid);

      //==========================================================
      // NAVIGATE IMMEDIATELY
      //==========================================================

      Get.offAllNamed(AppRoutes.landing);

      //==========================================================
      // NON-CRITICAL TASKS IN BACKGROUND
      //==========================================================

      unawaited(_finishSignupInBackground(firebaseUser));
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('Signup error: $e');

      Snack_Bar.show(
        title: "Signup Failed",
        message: "Something went wrong while creating your account.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isEmailLoading.value = false;
    }
  }

  Future<void> _finishSignupInBackground(User firebaseUser) async {
    try {
      // Send verification email without blocking navigation
      await _authService.sendEmailVerification();

      // Initialize FCM without blocking navigation
      await _fcmService.initialize();

      debugPrint('Background signup setup completed successfully.');
    } catch (e) {
      debugPrint('Background signup setup error: $e');
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // SUCCESSFUL AUTHENTICATION
  //============================================================
  //============================================================
  //============================================================

  Future<void> _handleSuccessfulAuthentication(User firebaseUser) async {
    //============================================================
    // NAVIGATE IMMEDIATELY
    //============================================================

    Get.offAllNamed(AppRoutes.landing);

    //============================================================
    // BACKGROUND PROFILE + FCM
    //============================================================

    unawaited(_finishAuthenticationInBackground(firebaseUser));
  }

  Future<void> _finishAuthenticationInBackground(User firebaseUser) async {
    try {
      //==========================================================
      // CREATE USER PROFILE IF NEEDED
      //==========================================================

      final bool exists = await _userService.userExists(firebaseUser.uid);

      if (!exists) {
        await _userService.createUser(
          firebaseUser: firebaseUser,
          name: firebaseUser.displayName ?? '',
          phoneNumber: firebaseUser.phoneNumber ?? '',
          profileImage: firebaseUser.photoURL,
        );
      }

      //==========================================================
      // LOAD USER PROFILE
      //==========================================================

      await userController.loadUser(firebaseUser.uid);

      //==========================================================
      // INITIALIZE FCM
      //==========================================================

      await _fcmService.initialize();

      debugPrint('Background authentication setup completed.');
    } catch (e) {
      // Authentication itself already succeeded.
      // Do not block the user or show an authentication
      // failure message after navigation.
      debugPrint('Background authentication setup error: $e');
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // INITIALIZE GOOGLE SIGN IN
  //============================================================
  //============================================================
  //============================================================

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _authService.initializeGoogleSignIn();

      debugPrint('Google Sign In initialized successfully.');
    } catch (e) {
      debugPrint('Google Sign In initialization error: $e');
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // SEND PHONE OTP
  //============================================================
  //============================================================
  //============================================================

  Future<void> sendPhoneOTP({int? forceResendingToken}) async {
    final String enteredNumber = phoneController.text.trim();

    if (enteredNumber.isEmpty) {
      Snack_Bar.show(
        title: 'Phone Required',
        message: "Please enter your phone number.",
        icon: FontAwesomeIcons.circleExclamation,
      );
      return;
    }

    final String digits = enteredNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 10) {
      Snack_Bar.show(
        title: 'Invalid Phone Number',
        message: "Please enter a valid 10-digit US phone number.",
        icon: FontAwesomeIcons.circleExclamation,
      );
      return;
    }

    final String phoneNumber = '+1$digits';

    requestedPhoneNumber.value = phoneNumber;

    try {
      isSendOTPLoading.value = true;

      await _authService.sendPhoneOTP(
        phoneNumber: phoneNumber,

        onVerificationCompleted: (PhoneAuthCredential credential) async {
          try {
            debugPrint('Phone verification completed automatically.');

            final UserCredential userCredential = await FirebaseAuth.instance
                .signInWithCredential(credential);

            final User? firebaseUser = userCredential.user;

            if (firebaseUser != null) {
              await _handleSuccessfulAuthentication(firebaseUser);
            }
          } on FirebaseAuthException catch (e) {
            _showAuthError(e);
          } catch (e) {
            debugPrint('Automatic phone verification error: $e');
          }
        },

        onVerificationFailed: (FirebaseAuthException error) {
          isSendOTPLoading.value = false;
          _showAuthError(error);
        },

        onCodeSent: (String id, int? resendToken) async {
          verificationId.value = id;

          _resendToken = resendToken;

          startResendCountdown();

          Snack_Bar.show(
            title: "OTP Sent",
            message: "Verification code sent to your phone.",
            icon: FontAwesomeIcons.solidCircleCheck,
          );

          // Keep ThreeBounce visible while navigating.
          await Get.toNamed(AppRoutes.otpVerfication);

          // Stop loading after OTP screen is opened.
          isSendOTPLoading.value = false;
        },

        onCodeAutoRetrievalTimeout: (String id) {
          verificationId.value = id;

          debugPrint('Phone code auto retrieval timed out.');
        },

        forceResendingToken: forceResendingToken,
      );
    } on FirebaseAuthException catch (e) {
      isSendOTPLoading.value = false;
      _showAuthError(e);
    } catch (e) {
      isSendOTPLoading.value = false;

      debugPrint('Phone OTP error: $e');

      Snack_Bar.show(
        title: "OTP Failed",
        message: "Unable to send the verification code.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    }
  }
  //============================================================
  //============================================================
  //============================================================
  // START OTP RESEND COUNTDOWN
  //============================================================
  //============================================================
  //============================================================

  void startResendCountdown() {
    _resendTimer?.cancel();

    resendSeconds.value = 60;

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value <= 1) {
        resendSeconds.value = 0;

        timer.cancel();
      } else {
        resendSeconds.value--;
      }
    });
  }

  //============================================================
  //============================================================
  //============================================================
  // RESEND PHONE OTP
  //============================================================
  //============================================================
  //============================================================

  Future<void> resendPhoneOTP() async {
    if (!canResendOTP) {
      return;
    }

    if (phoneController.text.trim().isEmpty) {
      Snack_Bar.show(
        title: "Phone Required",
        message: "Please enter your phone number again.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    await sendPhoneOTP(forceResendingToken: _resendToken);
  }

  //============================================================
  //============================================================
  //============================================================
  // VERIFY PHONE OTP
  //============================================================
  //============================================================
  //============================================================

  Future<void> verifyPhoneOTP() async {
    if (verificationId.value.isEmpty) {
      Snack_Bar.show(
        title: "OTP Error",
        message: "Please request a verification code first.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    final String smsCode = otpController.text.trim();

    if (smsCode.isEmpty) {
      Snack_Bar.show(
        title: "OTP Required",
        message: "Please enter the verification code.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    if (!RegExp(r'^\d{6}$').hasMatch(smsCode)) {
      Snack_Bar.show(
        title: "Invalid OTP",
        message: "Please enter the 6-digit verification code.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    try {
      isVerifyOTPLoading.value = true;

      final UserCredential credential = await _authService.verifyPhoneOTP(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        Snack_Bar.show(
          title: 'Verification Failed',
          message: "Firebase did not return a user.",
          icon: FontAwesomeIcons.circleExclamation,
        );

        return;
      }

      await _handleSuccessfulAuthentication(firebaseUser);
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('OTP verification error: $e');

      Snack_Bar.show(
        title: "Verification Failed",
        message: "Unable to verify the code.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isVerifyOTPLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // SEND PASSWORD RESET EMAIL
  //============================================================
  //============================================================
  //============================================================

  Future<void> sendPasswordResetEmail() async {
    final String email = resetEmailController.text.trim();

    if (email.isEmpty) {
      Snack_Bar.show(
        title: "Email Required",
        message: "Please enter your email address.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    try {
      isEmailLoading.value = true;

      await _authService.sendPasswordResetEmail(email: email);
      Get.back();
      Snack_Bar.show(
        title: "Reset Email Sent",
        message: "Check your email for password reset instructions.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      Snack_Bar.show(
        title: "Reset Failed",
        message: "Unable to send the password reset email.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      debugPrint('Password reset error: $e');
    } finally {
      isEmailLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // GOOGLE LOGIN
  //============================================================
  //============================================================
  //============================================================

  Future<void> loginWithGoogle() async {
    try {
      isGoogleLoading.value = true;

      final UserCredential credential = await _authService.signInWithGoogle();

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        Snack_Bar.show(
          title: "Google Login Failed",
          message: "Firebase did not return a user.",
          icon: FontAwesomeIcons.circleExclamation,
        );
        return;
      }

      await _handleSuccessfulAuthentication(firebaseUser);
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('Google login error: $e');

      Snack_Bar.show(
        title: "Google Login Failed",
        message: "Unable to sign in with Google.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // FACEBOOK LOGIN
  //============================================================
  //============================================================
  //============================================================

  Future<void> loginWithFacebook() async {
    try {
      debugPrint('AUTH CONTROLLER: Facebook button pressed');

      isFacebookLoading.value = true;

      debugPrint('AUTH CONTROLLER: Calling AuthService...');

      final UserCredential credential = await _authService.signInWithFacebook();

      debugPrint('AUTH CONTROLLER: AuthService returned.');

      final User? firebaseUser = credential.user;

      if (firebaseUser == null) {
        Snack_Bar.show(
          title: "Facebook Login Failed",
          message: "Firebase did not return a user.",
          icon: FontAwesomeIcons.circleExclamation,
        );
        return;
      }

      await _handleSuccessfulAuthentication(firebaseUser);
    } on FirebaseAuthException catch (e) {
      debugPrint('AUTH CONTROLLER FIREBASE ERROR: ${e.code}');
      debugPrint('AUTH CONTROLLER FIREBASE MESSAGE: ${e.message}');

      _showAuthError(e);
    } catch (e) {
      debugPrint('AUTH CONTROLLER FACEBOOK ERROR: $e');

      Snack_Bar.show(
        title: 'Facebook Login Failed',
        message: "Unable to sign in with Facebook.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isFacebookLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // RESET PASSWORD
  //============================================================
  //============================================================
  //============================================================

  // Future<void> resetPassword() async {
  //   final String email = resetEmailController.text.trim();

  //   if (email.isEmpty) {
  //     Snack_Bar.show(
  //       title: "Email Required",
  //       message: "Please enter your email address.",
  //       icon: FontAwesomeIcons.circleExclamation,
  //     );

  //     return;
  //   }

  //   try {
  //     isLoading.value = true;

  //     await _authService.sendPasswordResetEmail(email: email);
  //     Snack_Bar.show(
  //       title: "Reset Email Sent",
  //       message: "Check your email for password reset instructions.",
  //       icon: FontAwesomeIcons.circleExclamation,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     _showAuthError(e);
  //   } catch (e) {
  //     debugPrint('Reset password error: $e');
  //     Snack_Bar.show(
  //       title: "Reset Failed",
  //       message: "Unable to send the password reset email.",
  //       icon: FontAwesomeIcons.circleExclamation,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  //============================================================
  //============================================================
  //============================================================
  // EMAIL VERIFICATION
  //============================================================
  //============================================================
  //============================================================

  Future<void> sendEmailVerification() async {
    try {
      isEmailLoading.value = true;

      await _authService.sendEmailVerification();

      Snack_Bar.show(
        title: "Verification Email Sent",
        message: "Please check your email and verify your account.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('Email verification error: $e');
      Snack_Bar.show(
        title: "Verification Failed",
        message: "Unable to send verification email.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isEmailLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // LOGOUT
  //============================================================
  //============================================================
  //============================================================

  Future<void> logout() async {
    try {
      isLogoutLoading.value = true;

      await _authService.logout();

      userController.clearUser();

      Get.offAllNamed(AppRoutes.methodSelection);
    } catch (e) {
      debugPrint('Logout error: $e');

      Snack_Bar.show(
        title: "Logout Failed",
        message: "Unable to log out. Please try again.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isLogoutLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // PASSWORD VISIBILITY
  //============================================================
  //============================================================
  //============================================================

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.toggle();
  }

  //============================================================
  //============================================================
  //============================================================
  // CLEAR FORM
  //============================================================
  //============================================================
  //============================================================

  void clearFields() {
    nameController.clear();
    loginEmailController.clear();
    signupEmailController.clear();
    resetEmailController.clear();
    phoneController.clear();
    loginPasswordController.clear();
    signupPasswordController.clear();
    signupConfirmPasswordController.clear();
    otpController.clear();

    verificationId.value = '';

    _resendToken = null;

    resendSeconds.value = 0;

    _resendTimer?.cancel();
  }

  //============================================================
  //============================================================
  //============================================================
  // AUTH ERROR HANDLER
  //============================================================
  //============================================================
  //============================================================

  void _showAuthError(FirebaseAuthException error) {
    String message;

    switch (error.code) {
      case 'invalid-email':
        message = 'Please enter a valid email address.';
        break;

      case 'user-disabled':
        message = 'This account has been disabled.';
        break;

      case 'user-not-found':
        message = 'No account exists with this email.';
        break;

      case 'wrong-password':
      case 'invalid-credential':
        message = 'Incorrect email or password.';
        break;

      case 'email-already-in-use':
        message = 'An account already exists with this email.';
        break;

      case 'weak-password':
        message = 'Please choose a stronger password.';
        break;

      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;

      case 'network-request-failed':
        message = 'Please check your internet connection.';
        break;

      case 'operation-not-allowed':
        message = 'This sign-in method is not enabled in Firebase.';
        break;

      case 'invalid-verification-code':
        message = 'The verification code is invalid.';
        break;

      case 'invalid-verification-id':
        message =
            'The verification session has expired. Please request a new code.';
        break;

      case 'code-expired':
        message =
            'The verification code has expired. Please request a new code.';
        break;

      case 'credential-already-in-use':
        message =
            'This phone number is already associated with another account.';
        break;

      case 'session-expired':
        message =
            'The verification session expired. Please request a new code.';
        break;

      case 'quota-exceeded':
        message =
            'SMS verification quota has been exceeded. Please try again later.';
        break;

      case 'invalid-phone-number':
        message = 'Please enter a valid US phone number.';
        break;

      case 'facebook-login-cancelled':
        message = 'Facebook login was cancelled.';
        break;

      default:
        message = error.message ?? 'Authentication failed. Please try again.';
    }

    Snack_Bar.show(
      title: "Authentication Error",
      message: message,
      icon: FontAwesomeIcons.circleExclamation,
    );
  }

  //============================================================
  //============================================================
  //============================================================
  // UPDATE EMAIL
  //============================================================
  //============================================================
  //============================================================

  Future<void> updateEmail(String newEmail) async {
    final String email = newEmail.trim();

    if (email.isEmpty) {
      Snack_Bar.show(
        title: 'Email Required',
        message: 'Please enter your new email address.',
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    try {
      isEmailLoading.value = true;

      final User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser == null) {
        Snack_Bar.show(
          title: "Authentication Error",
          message: "Please log in again.",
          icon: FontAwesomeIcons.circleExclamation,
        );

        return;
      }

      await _authService.updateEmail(newEmail: email);

      await _userService.updateUser(uid: firebaseUser.uid, email: email);

      await firebaseUser.reload();

      final User? updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser != null) {
        await userController.loadUser(updatedUser.uid);
      }

      Snack_Bar.show(
        title: "Email Updated",
        message:
            "A verification email has been sent to your new email address.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('Update email error: $e');

      Snack_Bar.show(
        title: "Email Update Failed",
        message: "Unable to update your email address.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isEmailLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // UPDATE PASSWORD
  //============================================================
  //============================================================
  //============================================================

  Future<void> updatePassword(String newPassword) async {
    if (newPassword.trim().isEmpty) {
      Snack_Bar.show(
        title: "Password Required",
        message: "Please enter a new password.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    if (newPassword.length < 6) {
      Snack_Bar.show(
        title: "Weak Password",
        message: "Password must be at least 6 characters.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return;
    }

    try {
      isEmailLoading.value = true;

      await _authService.updatePassword(newPassword: newPassword.trim());

      Snack_Bar.show(
        title: "Password Updated",
        message: "Your password has been changed successfully.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    } catch (e) {
      debugPrint('Update password error: $e');

      Snack_Bar.show(
        title: "Password Update Failed",
        message: "Unable to update your password.",
        icon: FontAwesomeIcons.circleExclamation,
      );
    } finally {
      isEmailLoading.value = false;
    }
  }

  //============================================================
  //============================================================
  //============================================================
  // DISPOSE
  //============================================================
  //============================================================
  //============================================================

  @override
  void onClose() {
    _resendTimer?.cancel();

    nameController.dispose();
    loginEmailController.dispose();
    signupEmailController.clear();
    resetEmailController.clear();
    phoneController.dispose();
    loginPasswordController.clear();
    signupPasswordController.clear();
    signupConfirmPasswordController.clear();
    otpController.dispose();

    super.onClose();
  }
}
