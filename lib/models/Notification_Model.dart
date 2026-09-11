// ignore_for_file: file_names

import 'package:quick_bite/enums/Notification_Type.dart';

class NotificationModel {
  //============================================================
  // BASIC INFORMATION
  //============================================================

  final String id;

  final String title;

  final String message;

  final NotificationType type;

  //============================================================
  // TARGET INFORMATION
  //============================================================

  /// What this notification is related to.
  ///
  /// Examples:
  /// "order"
  /// "customer"
  /// "deal"
  /// "offer"
  final String? target;

  /// ID of the target.
  ///
  /// For order notifications this will contain
  /// the order ID.
  final String? targetId;

  /// Order ID associated with this notification.
  final String? orderId;

  //============================================================
  // READ STATUS
  //============================================================

  bool isRead;

  //============================================================
  // CREATED TIME
  //============================================================

  final DateTime createdAt;

  //============================================================
  // CONSTRUCTOR
  //============================================================

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.target,
    this.targetId,
    this.orderId,
    this.isRead = false,
    required this.createdAt,
  });

  //============================================================
  // NOTIFICATION ICON
  //============================================================

  String get icon {
    switch (type) {
      case NotificationType.order:
        return "🛵";

      case NotificationType.deal:
        return "🔥";

      case NotificationType.offer:
        return "🎟️";

      case NotificationType.review:
        return "⭐";

      case NotificationType.general:
        return "🔔";
    }
  }
}