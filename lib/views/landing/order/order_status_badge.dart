// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/theme/app_colors.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.pending:
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        text = "Pending";
        break;

      case OrderStatus.confirmed:
        backgroundColor = Colors.indigo.shade50;
        textColor = Colors.indigo;
        text = "Confirmed";
        break;

      case OrderStatus.preparing:
        backgroundColor = Colors.blue.shade50;
        textColor = Colors.blue;
        text = "Preparing";
        break;

      case OrderStatus.ready:
        backgroundColor = Colors.deepPurple.shade50;
        textColor = Colors.deepPurple;
        text = "Ready";
        break;

      case OrderStatus.onTheWay:
        backgroundColor = Colors.purple.shade50;
        textColor = Colors.purple;
        text = "On The Way";
        break;

      case OrderStatus.delivered:
        backgroundColor = Colors.green.shade50;
        textColor = Colors.green;
        text = "Delivered";
        break;

      case OrderStatus.cancelled:
        backgroundColor = Colors.red.shade50;
        textColor = Colors.red;
        text = "Cancelled";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
