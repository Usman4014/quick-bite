// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Notification_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/notifications/empty_notification.dart';
import 'package:quick_bite/views/landing/home/notifications/notification_card.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/shimmers/notification_shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();

    // Start a fresh Firestore loading cycle
    notificationController.listenToNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              App_Bar(),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  //==========================================================
                  // LOADING
                  //==========================================================

                  if (notificationController.isLoading.value) {
                    return const NotificationShimmer();
                  }

                  //==========================================================
                  // EMPTY
                  //==========================================================

                  if (notificationController.notifications.isEmpty) {
                    return const EmptyNotification();
                  }

                  //==========================================================
                  // NOTIFICATIONS
                  //==========================================================

                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notificationController.notifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          notificationController.notifications[index];

                      return NotificationCard(
                        notification: notification,
                        onTap: () {
                          notificationController.handleNotificationTap(
                            notification,
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget App_Bar() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Back_Button(),
              SizedBox(width: 15),
              Text('Notifications', style: AppTextTheme.appbarText),
            ],
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,

            color: Colors.white,

            elevation: 8,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),

            icon: const Icon(Icons.more_vert, color: Colors.black, size: 24),

            onSelected: (value) {
              if (value == "read") {
                notificationController.markAllAsRead();
              }

              if (value == "clear") {
                // We will connect this to Firestore
                // after implementing customer notification deletion.
              }
            },

            itemBuilder: (context) => [
              PopupMenuItem(
                value: "read",

                child: Row(
                  children: [
                    const Icon(
                      Icons.done_all_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      "Mark all read",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuItem(
                value: "clear",

                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      "Clear all",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
