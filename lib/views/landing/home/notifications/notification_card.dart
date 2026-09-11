// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Notification_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  String getTimeAgo(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 12),

        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.yellow.shade50,

          borderRadius: BorderRadius.circular(15),

        border: Border.all(
            color: notification.isRead
                ? Colors.grey.shade300
                : AppColors.primary.withValues(alpha: 0.2),

            width: notification.isRead ? 1 : 2,
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Notification Icon
            Container(
              height: 52,

              width: 52,

              decoration: BoxDecoration(
                color: Colors.yellow.shade100,

                shape: BoxShape.circle,
              ),

              child: Center(
                child: Text(
                  notification.icon,

                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,

                          maxLines: 1,

                          overflow: TextOverflow.ellipsis,

                          style: GoogleFonts.poppins(
                            fontSize: 15,

                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                          ),
                        ),
                      ),

                      if (!notification.isRead)
                        Container(
                          height: 9,

                          width: 9,

                          decoration: const BoxDecoration(
                            color: Colors.red,

                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification.message,

                    maxLines: 2,

                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.poppins(
                      fontSize: 12,

                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    getTimeAgo(notification.createdAt),

                    style: GoogleFonts.poppins(
                      fontSize: 11,

                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
