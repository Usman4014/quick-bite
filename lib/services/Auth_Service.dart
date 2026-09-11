// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_service.dart';

class AuthService {
  //============================================================
  // FIREBASE AUTH
  //============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //============================================================
  // USER SERVICE
  //============================================================

  final UserService _userService = UserService();

  //============================================================
  // GOOGLE SIGN IN
  //============================================================

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  //============================================================
  // INITIALIZE GOOGLE
  //============================================================

  Future<void> initializeGoogleSignIn() async {
    await _googleSignIn.initialize();
  }

  //============================================================
  // CURRENT USER
  //============================================================

  User? get currentUser {
    return _auth.currentUser;
  }

  //============================================================
  // AUTH STATE
  //============================================================

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  //============================================================
  // SYNC FIREBASE AUTH EMAIL WITH FIRESTORE
  //============================================================
  //
  // This is important for email changes.
  //
  // Firebase Authentication changes the email after the user
  // completes the verification process.
  //
  // Firestore does NOT automatically know about that change.
  //
  // So we compare Firebase Auth email with Firestore and update
  // Firestore when necessary.
  //
  //============================================================

  Future<void> syncEmailWithFirestore() async {
    final User? firebaseUser = _auth.currentUser;

    if (firebaseUser == null) {
      return;
    }

    //==========================================================
    // REFRESH FIREBASE USER
    //==========================================================

    await firebaseUser.reload();

    final User? refreshedUser = _auth.currentUser;

    if (refreshedUser == null) {
      return;
    }

    await _userService.createUserIfNotExists(
      firebaseUser: refreshedUser,
      name: refreshedUser.displayName ?? '',
      phoneNumber: refreshedUser.phoneNumber ?? '',
      profileImage: refreshedUser.photoURL,
    );
  }

  //============================================================
  // EMAIL LOGIN
  //============================================================

  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    //==========================================================
    // SYNC EMAIL AFTER LOGIN
    //==========================================================

    await syncEmailWithFirestore();

    return credential;
  }

  //============================================================
  // EMAIL SIGN UP
  //============================================================

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  //============================================================
  // UPDATE DISPLAY NAME
  //============================================================

  Future<void> updateDisplayName({required String displayName}) async {
    if (displayName.trim().isEmpty) {
      return;
    }

    await _auth.currentUser?.updateDisplayName(displayName.trim());

    await _auth.currentUser?.reload();
  }

  //============================================================
  // UPDATE EMAIL
  //============================================================

  Future<void> updateEmail({required String newEmail}) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    final String email = newEmail.trim().toLowerCase();

    if (email.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-email',
        message: 'Email address cannot be empty.',
      );
    }

    //==========================================================
    // SEND VERIFICATION BEFORE EMAIL CHANGE
    //==========================================================
    //
    // Firebase will change Authentication email only after the
    // verification process is completed.
    //
    //==========================================================

    await user.verifyBeforeUpdateEmail(email);
  }

  //============================================================
  // UPDATE PASSWORD
  //============================================================

  Future<void> updatePassword({required String newPassword}) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    await user.updatePassword(newPassword);
  }

  //============================================================
  // SEND EMAIL VERIFICATION
  //============================================================

  Future<void> sendEmailVerification() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  //============================================================
  // PASSWORD RESET EMAIL
  //============================================================

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  //============================================================
  // PHONE OTP
  //============================================================

  Future<void> sendPhoneOTP({
    required String phoneNumber,

    required void Function(PhoneAuthCredential credential)
    onVerificationCompleted,

    required void Function(FirebaseAuthException error) onVerificationFailed,

    required void Function(String verificationId, int? resendToken) onCodeSent,

    required void Function(String verificationId) onCodeAutoRetrievalTimeout,

    int? forceResendingToken,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber.trim(),

      verificationCompleted: onVerificationCompleted,

      verificationFailed: onVerificationFailed,

      codeSent: onCodeSent,

      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,

      forceResendingToken: forceResendingToken,

      timeout: const Duration(seconds: 60),
    );
  }

  //============================================================
  // VERIFY PHONE OTP
  //============================================================

  Future<UserCredential> verifyPhoneOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return await _auth.signInWithCredential(credential);
  }

  //============================================================
  //============================================================
  //============================================================
  // GOOGLE SIGN IN
  //============================================================
  //============================================================
  //============================================================

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential credentialResult = await _auth.signInWithCredential(
      credential,
    );

    final User? firebaseUser = credentialResult.user;

    if (firebaseUser == null) {
      throw FirebaseAuthException(
        code: 'google-firebase-user-missing',
        message: 'Firebase user was not returned.',
      );
    }

    await _userService.createUserIfNotExists(firebaseUser: firebaseUser);

    return credentialResult;
  }

  //============================================================
  //============================================================
  //============================================================
  // FACEBOOK SIGN IN
  //============================================================
  //============================================================
  //============================================================

 Future<UserCredential> signInWithFacebook() async {
  debugPrint('FACEBOOK: Starting login...');

  final LoginResult result = await FacebookAuth.instance.login(
    permissions: const [
      'email',
      'public_profile',
    ],
    loginBehavior: LoginBehavior.nativeWithFallback,
  );

  debugPrint('FACEBOOK: Login status = ${result.status}');
  debugPrint('FACEBOOK: Message = ${result.message}');

  if (result.status != LoginStatus.success) {
    if (result.status == LoginStatus.cancelled) {
      throw FirebaseAuthException(
        code: 'facebook-login-cancelled',
        message: 'Facebook login was cancelled.',
      );
    }

    throw FirebaseAuthException(
      code: 'facebook-login-failed',
      message: result.message ?? 'Facebook login failed.',
    );
  }

  debugPrint('FACEBOOK: Login successful.');

  final AccessToken? accessToken = result.accessToken;

  debugPrint(
    'FACEBOOK: Access token exists = ${accessToken != null}',
  );

  if (accessToken == null) {
    throw FirebaseAuthException(
      code: 'facebook-access-token-missing',
      message: 'Facebook access token was not returned.',
    );
  }

  //============================================================
  // GET FACEBOOK PROFILE DATA
  //============================================================

  debugPrint('FACEBOOK: Getting Facebook profile data...');

  final Map<String, dynamic> facebookData =
      await FacebookAuth.instance.getUserData(
    fields: 'id,name,email,picture.type(large)',
  );

  debugPrint(
    'FACEBOOK: Facebook data = $facebookData',
  );

  final String? facebookProfileImage =
      facebookData['picture']?['data']?['url'];

  debugPrint(
    'FACEBOOK: Facebook profile image = $facebookProfileImage',
  );

  //============================================================
  // FIREBASE AUTHENTICATION
  //============================================================

  debugPrint('FACEBOOK: Creating Firebase credential...');

  final OAuthCredential credential =
      FacebookAuthProvider.credential(
    accessToken.tokenString,
  );

  debugPrint('FACEBOOK: Signing into Firebase...');

  final UserCredential credentialResult =
      await _auth.signInWithCredential(credential);

  debugPrint(
    'FACEBOOK: Firebase login successful.',
  );

  final User? firebaseUser = credentialResult.user;

  debugPrint(
    'FACEBOOK: Firebase UID = ${firebaseUser?.uid}',
  );

  if (firebaseUser == null) {
    throw FirebaseAuthException(
      code: 'facebook-firebase-user-missing',
      message: 'Firebase user was not returned.',
    );
  }

  //============================================================
  // FIRESTORE USER
  //============================================================

  debugPrint(
    'FACEBOOK: Creating/checking Firestore user...',
  );

  await _userService.createUserIfNotExists(
    firebaseUser: firebaseUser,
    profileImage: facebookProfileImage,
  );

  debugPrint('FACEBOOK: COMPLETE.');

  return credentialResult;
}

  //============================================================
  // LOGOUT
  //============================================================

  Future<void> logout() async {
    await _auth.signOut();

    try {
      await _googleSignIn.signOut();
    } catch (_) {}

    try {
      await FacebookAuth.instance.logOut();
    } catch (_) {}
  }

  //============================================================
  // DELETE ACCOUNT
  //============================================================

  Future<void> deleteAccount() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No authenticated user found.',
      );
    }

    await user.delete();
  }
}
