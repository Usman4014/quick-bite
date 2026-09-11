// ignore_for_file: file_names

import 'dart:async';

import 'package:get/get.dart';

import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/enums/Notification_Type.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/models/Notification_Model.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/services/Notification_Service.dart';

class NotificationController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final NotificationService _service = NotificationService();

  //============================================================
  // ORDER CONTROLLER
  //============================================================

  final OrderController _orderController =
      Get.find<OrderController>();

  //============================================================
  // NOTIFICATIONS
  //============================================================

  final RxList<NotificationModel> notifications =
      <NotificationModel>[].obs;

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = true.obs;

  //============================================================
  // UNREAD COUNT
  //============================================================

  final RxInt unreadCount = 0.obs;

  //============================================================
  // STREAM SUBSCRIPTION
  //============================================================

  StreamSubscription<List<NotificationModel>>?
      _notificationSubscription;

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    listenToNotifications();
  }

  //============================================================
  // LISTEN TO NOTIFICATIONS
  //============================================================

  void listenToNotifications() {
    isLoading.value = true;

    _notificationSubscription?.cancel();

    _notificationSubscription =
        _service.getCustomerNotifications().listen(
      (notificationList) {
        notifications.assignAll(notificationList);

        _updateUnreadCount();

        isLoading.value = false;
      },
      onError: (_) {
        isLoading.value = false;
      },
    );
  }

  //============================================================
  // UPDATE UNREAD COUNT
  //============================================================

  void _updateUnreadCount() {
    var count = 0;

    for (final notification in notifications) {
      if (!notification.isRead) {
        count++;
      }
    }

    unreadCount.value = count;
  }

  //============================================================
  // ADD NOTIFICATION
  //============================================================

  void addNotification(
    NotificationModel notification,
  ) {
    notifications.insert(0, notification);

    if (!notification.isRead) {
      unreadCount.value++;
    }
  }

  //============================================================
  // MARK ONE AS READ
  //============================================================

  Future<void> markAsRead(
    NotificationModel notification,
  ) async {
    if (notification.isRead) {
      return;
    }

    try {
      await _service.markAsRead(notification.id);

      notification.isRead = true;

      if (unreadCount.value > 0) {
        unreadCount.value--;
      }

      notifications.refresh();
    } catch (_) {
      // Keep local state unchanged if Firestore fails.
    }
  }

  //============================================================
  // HANDLE NOTIFICATION TAP
  //============================================================

  Future<void> handleNotificationTap(
    NotificationModel notification,
  ) async {
    //==========================================================
    // MARK AS READ
    //==========================================================

    await markAsRead(notification);

    //==========================================================
    // ONLY ORDER NOTIFICATIONS NAVIGATE
    //==========================================================

    if (notification.type != NotificationType.order) {
      return;
    }

    //==========================================================
    // GET ORDER ID
    //==========================================================

    final String? orderId =
        notification.orderId ??
        notification.targetId;

    if (orderId == null || orderId.trim().isEmpty) {
      return;
    }

    //==========================================================
    // FIND ORDER
    //==========================================================

    OrderModel? order =
        _orderController.getOrderById(orderId);

    //==========================================================
    // ORDER NOT LOADED YET
    //==========================================================

    if (order == null) {
      _orderController.startOrdersListener();

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      order = _orderController.getOrderById(orderId);
    }

    //==========================================================
    // ORDER STILL NOT FOUND
    //==========================================================

    if (order == null) {
      return;
    }

    //==========================================================
    // ACTIVE ORDER
    //==========================================================

    if (order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled) {
      Get.toNamed(
        AppRoutes.trackOrder,
        arguments: order,
      );

      return;
    }

    //==========================================================
    // COMPLETED / CANCELLED ORDER
    //==========================================================

    Get.toNamed(
      AppRoutes.orderDetails,
      arguments: order,
    );
  }

  //============================================================
  // MARK ALL AS READ
  //============================================================

  Future<void> markAllAsRead() async {
    if (notifications.isEmpty || unreadCount.value == 0) {
      return;
    }

    try {
      await _service.markAllAsRead();

      for (final notification in notifications) {
        notification.isRead = true;
      }

      unreadCount.value = 0;

      notifications.refresh();
    } catch (_) {
      // Keep local state unchanged if Firestore fails.
    }
  }

  //============================================================
  // UNREAD COUNT
  //============================================================

  int get unreadNotificationsCount =>
      unreadCount.value;

  //============================================================
  // CLEAR ALL
  //============================================================

  void clearNotification() {
    notifications.clear();
    unreadCount.value = 0;
  }

  //============================================================
  // FIND NOTIFICATION BY ID
  //============================================================

  NotificationModel? getNotificationById(
    String id,
  ) {
    for (final notification in notifications) {
      if (notification.id == id) {
        return notification;
      }
    }

    return null;
  }

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    _notificationSubscription = null;

    super.onClose();
  }
}