// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';

class FCMService {
  //============================================================
  // FIREBASE MESSAGING
  //============================================================

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //============================================================
  // AUTH
  //============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //============================================================
  // LOCAL NOTIFICATIONS
  //============================================================

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  //============================================================
  // ANDROID CHANNEL
  //============================================================

  static const AndroidNotificationChannel _notificationChannel =
      AndroidNotificationChannel(
        'quick_bite_notifications',
        'Quick Bite Notifications',
        description: 'Notifications from Quick Bite.',
        importance: Importance.high,
        playSound: true,
      );

  //============================================================
  // INITIALIZATION GUARD
  //============================================================

  bool _isInitialized = false;

  //============================================================
  // INITIALIZE FCM
  //============================================================

  Future<void> initialize() async {
    if (_isInitialized) {
      print('FCM: Already initialized.');
      return;
    }

    final user = _auth.currentUser;

    if (user == null) {
      print(
        'FCM: No authenticated user yet. '
        'Notification listeners will still be initialized.',
      );
    }

    //==========================================================
    // INITIALIZE LOCAL NOTIFICATIONS
    //==========================================================

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );

    //==========================================================
    // CREATE ANDROID CHANNEL
    //==========================================================

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _localNotifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidPlugin?.createNotificationChannel(_notificationChannel);

    //==========================================================
    // REQUEST FCM PERMISSION
    //==========================================================

    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    print(
      'FCM permission status: '
      '${settings.authorizationStatus}',
    );

    //==========================================================
    // REQUEST ANDROID NOTIFICATION PERMISSION
    //==========================================================

    await androidPlugin?.requestNotificationsPermission();

    //==========================================================
    // GET FCM TOKEN
    //==========================================================

    final String? token = await _messaging.getToken();

    if (token != null && token.isNotEmpty) {
      await saveToken(token);

      print('==========================================');
      print('FCM TOKEN');
      print(token);
      print('==========================================');
    } else {
      print('FCM: Unable to get token.');
    }

    //==========================================================
    // TOKEN REFRESH
    //==========================================================

    _messaging.onTokenRefresh.listen((newToken) async {
      print('FCM token refreshed.');

      await saveToken(newToken);
    });

    //==========================================================
    // FOREGROUND MESSAGE
    //==========================================================

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('==========================================');
      print('FCM FOREGROUND MESSAGE');

      print(
        'Title: '
        '${message.notification?.title}',
      );

      print(
        'Body: '
        '${message.notification?.body}',
      );

      print('Data: ${message.data}');

      print('==========================================');

      await _showForegroundNotification(message);
    });

    //==========================================================
    // BACKGROUND NOTIFICATION TAP
    //==========================================================

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('==========================================');

      print('FCM BACKGROUND NOTIFICATION TAPPED');

      print(
        'Title: '
        '${message.notification?.title}',
      );

      print(
        'Body: '
        '${message.notification?.body}',
      );

      print('Data: ${message.data}');

      print('==========================================');

      _handleNotificationTap(message.data);
    });

    //==========================================================
    // TERMINATED APP NOTIFICATION TAP
    //==========================================================

    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();

    if (initialMessage != null) {
      print('==========================================');

      print('FCM TERMINATED NOTIFICATION TAPPED');

      print(
        'Title: '
        '${initialMessage.notification?.title}',
      );

      print(
        'Body: '
        '${initialMessage.notification?.body}',
      );

      print('Data: ${initialMessage.data}');

      print('==========================================');

      _handleNotificationTap(initialMessage.data);
    }

    _isInitialized = true;

    print('FCM: Initialization completed.');
  }

  //============================================================
  // SHOW FOREGROUND NOTIFICATION
  //============================================================

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final String title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        'Quick Bite';

    final String body =
        message.notification?.body ?? message.data['message']?.toString() ?? '';

    if (body.isEmpty) {
      return;
    }

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'quick_bite_notifications',
          'Quick Bite Notifications',
          channelDescription: 'Notifications from Quick Bite.',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    final int notificationId =
        DateTime.now().millisecondsSinceEpoch % 2147483647;

    //==========================================================
    // STORE FCM DATA IN PAYLOAD
    //==========================================================

    final String payload = message.data.isEmpty
        ? ''
        : message.data.entries
              .map((entry) => '${entry.key}=${entry.value}')
              .join('&');

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  //============================================================
  // LOCAL NOTIFICATION TAP
  //============================================================

  void _onLocalNotificationTapped(NotificationResponse response) {
    print('==========================================');

    print('LOCAL NOTIFICATION TAPPED');

    print('Payload: ${response.payload}');

    print('==========================================');

    if (response.payload == null || response.payload!.isEmpty) {
      return;
    }

    final Map<String, String> data = _parsePayload(response.payload!);

    _handleNotificationTap(data);
  }

  //============================================================
  // PARSE LOCAL NOTIFICATION PAYLOAD
  //============================================================

  Map<String, String> _parsePayload(String payload) {
    final Map<String, String> data = {};

    final List<String> parts = payload.split('&');

    for (final String part in parts) {
      final int separator = part.indexOf('=');

      if (separator == -1) {
        continue;
      }

      final String key = part.substring(0, separator);

      final String value = part.substring(separator + 1);

      data[key] = value;
    }

    return data;
  }

  //============================================================
  // HANDLE NOTIFICATION TAP
  //============================================================

  void _handleNotificationTap(Map<String, dynamic> data) async {
    print('==========================================');

    print('HANDLING NOTIFICATION TAP');

    print('Notification data: $data');

    print('==========================================');

    final String? type = data['type']?.toString();

    final String? orderId = data['orderId']?.toString();

    print('Notification type: $type');

    print('Order ID: $orderId');

    if (type == 'order' && orderId != null && orderId.isNotEmpty) {
      await _openOrderFromNotification(orderId);

      return;
    }

    print(
      'FCM: No navigation action '
      'for this notification.',
    );
  }

  //============================================================
  // OPEN ORDER FROM NOTIFICATION
  //============================================================

  Future<void> _openOrderFromNotification(String orderId) async {
    print('FCM: Opening order: $orderId');

    //==========================================================
    // WAIT FOR GETX / APP TO BE READY
    //==========================================================

    for (int i = 0; i < 30; i++) {
      if (Get.context != null) {
        break;
      }

      await Future.delayed(const Duration(milliseconds: 200));
    }

    //==========================================================
    // CHECK ORDER CONTROLLER
    //==========================================================

    if (!Get.isRegistered<OrderController>()) {
      print(
        'FCM: OrderController is '
        'not registered.',
      );

      return;
    }

    final OrderController orderController = Get.find<OrderController>();

    //==========================================================
    // FIND ORDER
    //==========================================================

    OrderModel? order = orderController.getOrderById(orderId);

    //==========================================================
    // WAIT FOR ORDER LIST
    //==========================================================

    if (order == null) {
      print('FCM: Order not loaded yet.');

      print(
        'FCM: Waiting for order '
        'listener...',
      );

      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 300));

        order = orderController.getOrderById(orderId);

        if (order != null) {
          break;
        }
      }
    }

    //==========================================================
    // ORDER NOT FOUND
    //==========================================================

    if (order == null) {
      print('FCM: Order not found: $orderId');

      if (Get.context != null) {
        Get.snackbar(
          'Order Not Found',
          'Unable to open this order.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return;
    }

    print(
      'FCM: Order found: '
      '${order.orderId}',
    );

    print(
      'FCM: Order status: '
      '${order.status.name}',
    );

    //==========================================================
    // NAVIGATE ACCORDING TO STATUS
    //==========================================================

    switch (order.status) {
      //========================================================
      // ACTIVE ORDERS
      //========================================================

      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
      case OrderStatus.ready:
      case OrderStatus.onTheWay:
        print('FCM: Opening Track Order.');

        Get.toNamed(AppRoutes.trackOrder, arguments: order);

        break;

      //========================================================
      // DELIVERED
      //========================================================

      case OrderStatus.delivered:
        print('FCM: Opening Order Details.');

        Get.toNamed(AppRoutes.orderDetails, arguments: order);

        break;

      //========================================================
      // CANCELLED
      //========================================================

      case OrderStatus.cancelled:
        print(
          'FCM: Opening cancelled '
          'Order Details.',
        );

        Get.toNamed(AppRoutes.orderDetails, arguments: order);

        break;
    }
  }

  //============================================================
  // SAVE FCM TOKEN
  //============================================================

  Future<void> saveToken(String token) async {
    final user = _auth.currentUser;

    if (user == null) {
      print(
        'FCM: Cannot save token. '
        'No user.',
      );

      return;
    }

    final userReference = _firestore.collection('users').doc(user.uid);

    await userReference.set({
      'fcmTokens': FieldValue.arrayUnion([token]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    print(
      'FCM token saved for user: '
      '${user.uid}',
    );
  }

  //============================================================
  // REMOVE CURRENT TOKEN
  //============================================================

  Future<void> removeCurrentToken() async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    final String? token = await _messaging.getToken();

    if (token == null || token.isEmpty) {
      return;
    }

    await _firestore.collection('users').doc(user.uid).update({
      'fcmTokens': FieldValue.arrayRemove([token]),
    });
  }
}
