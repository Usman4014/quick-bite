import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:quick_bite/bindings/App_Binding.dart';
import 'package:quick_bite/firebase_options.dart';
import 'package:quick_bite/routes/App_Pages.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/services/FCM_Service.dart';
import 'package:quick_bite/theme/app_theme.dart';

//==============================================================
// FIREBASE BACKGROUND MESSAGE HANDLER
//==============================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    'FCM BACKGROUND MESSAGE: ${message.messageId}',
  );
}

//==============================================================
// MAIN
//==============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //============================================================
  // ORIENTATION
  //============================================================

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //============================================================
  // SYSTEM UI
  //============================================================

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  //============================================================
  // FIREBASE
  //============================================================

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //============================================================
  // FCM BACKGROUND HANDLER
  //============================================================

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  //============================================================
  // INITIALIZE FCM
  //
  // IMPORTANT:
  // This happens BEFORE runApp().
  // The service will register notification tap listeners.
  //============================================================

  final FCMService fcmService = FCMService();

  await fcmService.initialize();

  //============================================================
  // RUN APP
  //============================================================

  runApp(
    const MyApp(),
  );
}

//==============================================================
// APP
//==============================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Quick Bite',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,

      initialBinding: AppBinding(),

      initialRoute: AppRoutes.splash,

      getPages: AppPages.pages,

      defaultTransition:
          Transition.rightToLeft,

      transitionDuration:
          const Duration(
        milliseconds: 300,
      ),
    );
  }
}