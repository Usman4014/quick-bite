// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class OrderTimeline extends StatelessWidget {
  final OrderModel order;

  const OrderTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final bool isCancelled = order.status == OrderStatus.cancelled;

    if (isCancelled) {
      return _buildCancelledTimeline();
    }

    final int currentStep = _currentStep(order.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
       // color: Colors.white,
        //borderRadius: BorderRadius.circular(18),
        //border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "Order Timeline",
          //   style: GoogleFonts.poppins(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),

          // const SizedBox(height: 20),

          _timelineTile(
            leading: FontAwesomeIcons.receipt,
            title: "Order Placed",
            subtitle: "Waiting for confirmation.",
            trailing: DateFormat(
              "hh:mm a",
            ).format(order.orderDate),
            completed: currentStep >= 0,
            isLast: false,
          ),

          _timelineTile(
            leading: FontAwesomeIcons.circleCheck,
            title: "Order Confirmed",
            subtitle: "Restaurant confirmed your order.",
            trailing: currentStep >= 1
                ?  DateFormat(
              "hh:mm a",
            ).format(order.orderDate)
                : "",
            completed: currentStep >= 1,
            isLast: false,
          ),

          _timelineTile(
            leading: FontAwesomeIcons.utensils,
            title: "Preparing",
            subtitle: "Your meal is being prepared.",
            trailing: currentStep >= 2
                ?  DateFormat(
              "hh:mm a",
            ).format(order.orderDate)
                : "",
            completed: currentStep >= 2,
            isLast: false,
          ),

          _timelineTile(
            leading: FontAwesomeIcons.boxOpen,
            title: "Ready",
            subtitle: "Ready for rider pickup.",
            trailing: currentStep >= 3
                ?  DateFormat(
              "hh:mm a",
            ).format(order.orderDate)
                : "",
            completed: currentStep >= 3,
            isLast: false,
          ),

          _timelineTile(
            leading: FontAwesomeIcons.motorcycle,
            title: "On The Way",
            subtitle: "Your order is on the way.",
            trailing: currentStep >= 4
                ? DateFormat(
              "hh:mm a",
            ).format(order.orderDate)
                : "",
            completed: currentStep >= 4,
            isLast: false,
          ),

          _timelineTile(
            leading: FontAwesomeIcons.house,
            title: "Delivered",
            subtitle: "Delivered successfully.",
            trailing: order.deliveredAt != null
                ? DateFormat('hh:mm a').format(order.deliveredAt!)
                : "",
            completed: currentStep >= 5,
            isLast: true,
          ),
        ],
      ),
    );
  }

  int _currentStep(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;

      case OrderStatus.confirmed:
        return 1;

      case OrderStatus.preparing:
        return 2;

      case OrderStatus.ready:
        return 3;

      case OrderStatus.onTheWay:
        return 4;

      case OrderStatus.delivered:
        return 5;

      case OrderStatus.cancelled:
        return 0;
    }
  }

  Widget _timelineTile({
    required FaIconData leading,
    required String title,
    required String subtitle,
    required String trailing,
    required bool completed,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? AppColors.primary : Colors.grey.shade400,
                ),
                child: Center(child: FaIcon(leading,color: Colors.white,size: 16,))
              ),

              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: completed ? AppColors.primary : Colors.grey.shade400,
                  ),
                ),
            ],
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        trailing,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black
                        ),
                      ),
                    ],
                    
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelledTimeline() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Timeline",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          _timelineTile(
            leading:  FontAwesomeIcons.receipt,
            title: "Order Placed",
            subtitle: "Your order has been placed and is waiting for confirmation.",
            trailing: DateFormat(
              "dd MMM yyyy • hh:mm a",
            ).format(order.orderDate),
            completed: true,
            isLast: false,
          ),

          _timelineTile(
            leading: FontAwesomeIcons.circleXmark,
            title: "Cancelled",
            subtitle: "This order has been cancelled.",
            trailing:  DateFormat(
              "dd MMM yyyy • hh:mm a",
            ).format(order.orderDate),
            completed: true,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
