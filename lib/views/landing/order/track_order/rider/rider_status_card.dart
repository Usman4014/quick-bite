// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/theme/app_colors.dart';

class RiderStatusCard extends StatelessWidget {
  final OrderStatus status;

  const RiderStatusCard({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              statusData.icon,
              color: AppColors.primary,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          // Status information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusData.title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  statusData.description,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _RiderStatusData _getStatusData(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return _RiderStatusData(
          title: 'Order Placed',
          description: 'Your order has been received.',
          icon: Icons.receipt_long_rounded,
        );

      case OrderStatus.confirmed:
        return _RiderStatusData(
          title: 'Order Confirmed',
          description: 'Your order has been confirmed.',
          icon: Icons.check_circle_outline_rounded,
        );

      case OrderStatus.preparing:
        return _RiderStatusData(
          title: 'Preparing Your Order',
          description: 'The restaurant is preparing your food.',
          icon: Icons.restaurant_rounded,
        );

      case OrderStatus.ready:
        return _RiderStatusData(
          title: 'Rider Assigned',
          description: 'Your rider is ready to pick up your order.',
          icon: Icons.person_pin_circle_rounded,
        );

      case OrderStatus.onTheWay:
        return _RiderStatusData(
          title: 'On The Way',
          description: 'Your rider is bringing your order to you.',
          icon: Icons.delivery_dining_rounded,
        );

      case OrderStatus.delivered:
        return _RiderStatusData(
          title: 'Delivered',
          description: 'Your order has been delivered successfully.',
          icon: Icons.check_circle_rounded,
        );

      case OrderStatus.cancelled:
        return _RiderStatusData(
          title: 'Order Cancelled',
          description: 'This order has been cancelled.',
          icon: Icons.cancel_outlined,
        );
    }
  }
}

class _RiderStatusData {
  final String title;
  final String description;
  final IconData icon;

  const _RiderStatusData({
    required this.title,
    required this.description,
    required this.icon,
  });
}