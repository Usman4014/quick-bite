
// ignore_for_file: avoid_print, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quick_bite/models/User_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/services/User_Service.dart';
import 'dart:io';

import 'package:quick_bite/services/Cloudinary_Service.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class UserController extends GetxController {
  //============================================================
  // DEPENDENCIES
  //============================================================
  final RxBool isSaveChangesLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  //============================================================
  // CURRENT USER
  //============================================================

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    _loadCurrentFirebaseUser();
  }

  //============================================================
  // LOAD CURRENT FIREBASE USER
  //============================================================

  Future<void> _loadCurrentFirebaseUser() async {
    final User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      currentUser.value = null;
      return;
    }

    await loadUser(firebaseUser.uid);
  }

  //============================================================
  // LOAD USER FROM FIRESTORE
  //============================================================

  Future<void> loadUser(String uid) async {
    try {
      final Map<String, dynamic>? userData =
          await _userService.getUserData(uid);

      if (userData == null) {
        currentUser.value = null;
        return;
      }

      currentUser.value = UserModel(
        id: userData['id'] ?? uid,
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phoneNumber: userData['phoneNumber'] ?? '',
        profileImage: userData['profileImage'],

        // Nested Firestore models will be added
        // when their serialization is implemented.
        addresses: [],
        favoriteProducts: [],
        paymentMethods: [],
        notifications: [],
      );
    } catch (e) {
      currentUser.value = null;

      print('Error loading user: $e');
    }
  }

  Future<String?> uploadProfileImage(File imageFile) async {
  final User? firebaseUser = _auth.currentUser;

  if (firebaseUser == null) {
    throw Exception('No authenticated user.');
  }

  try {
    final String? imageUrl =
        await _cloudinaryService.uploadImage(
      imageFile: imageFile,
      folder: 'quick_bite/profile_images',
    );

    if (imageUrl == null) {
      throw Exception('Unable to upload image.');
    }

    // Save Cloudinary URL in Firestore
    await _userService.updateUser(
      uid: firebaseUser.uid,
      profileImage: imageUrl,
    );

    // Refresh local user
    await refreshUser();

    return imageUrl;
  } catch (e) {
    print('Profile image upload error: $e');
    rethrow;
  }
}

  //============================================================
  // SET USER
  //============================================================

  void setUser(UserModel user) {
    currentUser.value = user;
  }

  //============================================================
  // REFRESH USER
  //============================================================

  Future<void> refreshUser() async {
    final User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      currentUser.value = null;
      return;
    }

    await loadUser(firebaseUser.uid);
  }

 


//============================================================
// UPDATE PROFILE
//============================================================

Future<bool> updateProfile({
  String? name,
  String? email,
  String? phoneNumber,
  String? profileImage,
}) async {
  
  final User? firebaseUser = _auth.currentUser;

  if (firebaseUser == null) {
    throw Exception('No authenticated user.');
  }

  final String uid = firebaseUser.uid;


  //============================================================
  // CHECK WHETHER EMAIL IS ACTUALLY CHANGING
  //============================================================

  final String? newEmail =
      email?.trim().isNotEmpty == true
          ? email!.trim().toLowerCase()
          : null;


  final String? currentEmail =
      firebaseUser.email?.trim().toLowerCase();


  final bool emailIsChanging =
      newEmail != null &&
      newEmail != currentEmail;


  //============================================================
  // UPDATE FIREBASE AUTH EMAIL
  //============================================================

  if (emailIsChanging) {

    try {

      await firebaseUser.verifyBeforeUpdateEmail(
        newEmail,
      );

    } on FirebaseAuthException catch (e) {

      print(
        'Firebase email update error: '
        '${e.code} - ${e.message}',
      );

      rethrow;
    }
  }


  //============================================================
  // UPDATE FIREBASE AUTH DISPLAY NAME
  //============================================================

  if (name != null &&
      name.trim().isNotEmpty &&
      name.trim() != firebaseUser.displayName) {

    await firebaseUser.updateDisplayName(
      name.trim(),
    );
  }


  //============================================================
  // UPDATE FIREBASE AUTH PHOTO
  //============================================================

  if (profileImage != null &&
      profileImage.trim().isNotEmpty &&
      profileImage.trim() != firebaseUser.photoURL) {

    await firebaseUser.updatePhotoURL(
      profileImage.trim(),
    );
  }


  //============================================================
  // UPDATE FIRESTORE
  //============================================================
  //
  // IMPORTANT:
  //
  // If email is changing, DO NOT update the Firestore email yet.
  //
  // Firebase Auth is still waiting for verification.
  //
  // Name, phone number and profile image can be updated normally.
  //
  //============================================================

  await _userService.updateUser(
    uid: uid,
    name: name,
    email: emailIsChanging
        ? null
        : newEmail,
    phoneNumber: phoneNumber,
    profileImage: profileImage,
  );


  //============================================================
  // REFRESH LOCAL USER
  //============================================================

  await refreshUser();


  //============================================================
  // RETURN WHETHER EMAIL VERIFICATION WAS REQUESTED
  //============================================================

  return emailIsChanging;
}



Future<void> saveProfileChanges({
  required String name,
  required String email,
  required String phoneNumber,
}) async {
  //==========================================================
  // VALIDATION
  //==========================================================

  if (name.trim().isEmpty) {
    Snack_Bar.show(
      title: 'Name Required',
      message: 'Please enter your full name.',
      icon: FontAwesomeIcons.circleExclamation,
    );

    return;
  }

  if (email.trim().isEmpty) {
    Snack_Bar.show(
      title: 'Email Required',
      message: 'Please enter your email address.',
      icon: FontAwesomeIcons.circleExclamation,
    );

    return;
  }

  try {
    //========================================================
    // START LOADING
    //========================================================

   isSaveChangesLoading.value = true;

    //========================================================
    // CURRENT EMAIL
    //========================================================

    final String currentEmail = currentUser
        .value!
        .email
        .trim()
        .toLowerCase();

    final String newEmail =
        email.trim().toLowerCase();

    final bool emailChanged =
        currentEmail != newEmail;

    //========================================================
    // UPDATE PROFILE
    //========================================================

    final bool emailChangeRequested =
        await updateProfile(
          name: name.trim(),
          email: email.trim(),
          phoneNumber: phoneNumber.trim(),
        );

    //========================================================
    // EMAIL CHANGE REQUESTED
    //========================================================

    if (emailChangeRequested && emailChanged) {
      //======================================================
      // LOGOUT
      //======================================================

      await logout();

      //======================================================
      // GO TO LOGIN SCREEN
      //======================================================

      Get.offAllNamed(
        AppRoutes.methodSelection,
      );

      //======================================================
      // SHOW MESSAGE
      //======================================================

      Snack_Bar.show(
        title: 'Verify Your New Email',
        message:
            'A verification link has been sent to your new email. '
            'Please verify it before logging in again.',
        icon: FontAwesomeIcons.envelope,
      );

      return;
    }

    //========================================================
    // NORMAL PROFILE UPDATE
    //========================================================

    Get.back();

    Snack_Bar.show(
      title: 'Profile Updated',
      message:
          'Your profile has been updated successfully.',
      icon: FontAwesomeIcons.solidCircleCheck,
    );
  } catch (e) {
    Snack_Bar.show(
      title: 'Update Failed',
      message: e.toString(),
      icon: FontAwesomeIcons.circleExclamation,
    );
  } finally {
    //========================================================
    // STOP LOADING
    //========================================================

    isSaveChangesLoading.value = false;
  }
}



 
//============================================================
// CHANGE PASSWORD
//============================================================

Future<void> changePassword({
  required String newPassword,
  required String confirmPassword,
}) async {
  final User? firebaseUser = _auth.currentUser;

  if (firebaseUser == null) {
    throw Exception('No authenticated user.');
  }

  final String password = newPassword.trim();
  final String confirmation = confirmPassword.trim();

  //==========================================================
  // VALIDATION
  //==========================================================

  if (password.isEmpty) {
    throw Exception('Please enter a new password.');
  }

  if (password.length < 6) {
    throw Exception('Password must be at least 6 characters.');
  }

  if (confirmation.isEmpty) {
    throw Exception('Please confirm your new password.');
  }

  if (password != confirmation) {
    throw Exception('Passwords do not match.');
  }

  //==========================================================
  // UPDATE FIREBASE AUTH PASSWORD
  //==========================================================

  try {
    await firebaseUser.updatePassword(password);
  } on FirebaseAuthException catch (e) {
    print('Change password error: ${e.code}');

    if (e.code == 'requires-recent-login') {
      throw Exception(
        'For security, please log in again before changing your password.',
      );
    }

    if (e.code == 'weak-password') {
      throw Exception(
        'Please choose a stronger password.',
      );
    }

    rethrow;
  }
}


  //============================================================
  // LOGOUT
  //============================================================

  Future<void> logout() async {
    try {
      await _auth.signOut();

      currentUser.value = null;
    } catch (e) {
      print('Error during logout: $e');

      rethrow;
    }
  }


 
//============================================================
// SYNC FIREBASE AUTH DATA TO FIRESTORE
//============================================================

Future<void> syncAuthUserToFirestore() async {
  final User? firebaseUser = _auth.currentUser;

  if (firebaseUser == null) {
    throw Exception('No authenticated user.');
  }

  await _userService.updateUser(
    uid: firebaseUser.uid,
    name: firebaseUser.displayName,
    email: firebaseUser.email,
    phoneNumber: firebaseUser.phoneNumber,
    profileImage: firebaseUser.photoURL,
  );

  await refreshUser();
}



  //============================================================
  // CLEAR USER
  //============================================================

  void clearUser() {
    currentUser.value = null;
  }

  //============================================================
  // CHECK LOGIN STATUS
  //============================================================

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  //============================================================
  // FIREBASE USER
  //============================================================

  User? get firebaseUser {
    return _auth.currentUser;
  }

  //============================================================
  // FIREBASE UID
  //============================================================

  String? get firebaseUid {
    return _auth.currentUser?.uid;
  }

  //============================================================
  // EMAIL VERIFIED
  //============================================================

  bool get isEmailVerified {
    return _auth.currentUser?.emailVerified ?? false;
  }
}

