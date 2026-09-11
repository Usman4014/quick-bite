// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        // Open Order Details Screen
        // Get.toNamed(AppRoutes.orderDetails, arguments: order);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //---------------------------------------------------
            // Header
            //---------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.orderId,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),

                _statusChip(order.status),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              _formatDate(order.orderDate),
              style: GoogleFonts.poppins(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 18),

            //---------------------------------------------------
            // Items
            //---------------------------------------------------
            ...order.items
                .take(3)
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 7,
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                // decoration: BoxDecoration(
                                //   color: Colors.grey.shade100,
                                //   borderRadius: BorderRadius.circular(10),
                                // ),
                                child: Image.network(
                                  item.isSpecialDeal
                                      ? item.specialDeal!.squareImage
                                      : item.product!.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 20,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${item.isSpecialDeal ? item.specialDeal!.title : item.product!.name} × ${item.quantity}",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            if (order.items.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  "+${order.items.length - 3} more items",
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                ),
              ),

            const SizedBox(height: 18),

            Divider(color: Colors.grey.shade300),

            const SizedBox(height: 12),

            //---------------------------------------------------
            // Total
            //---------------------------------------------------
            Row(
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.poppins(color: Colors.grey.shade700),
                ),

                const Spacer(),

                Text(
                  "\$${order.totalAmount.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            //---------------------------------------------------
            // Button
            //---------------------------------------------------
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  if (order.status == OrderStatus.delivered ||
                      order.status == OrderStatus.cancelled) {
                    Get.toNamed(AppRoutes.orderDetails, arguments: order);
                  } else {
                    Get.toNamed(AppRoutes.trackOrder, arguments: order);
                  }
                },
                child: Text(
                  _buttonText(order.status),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //---------------------------------------------------
  // Status Chip
  //---------------------------------------------------

  Widget _statusChip(OrderStatus status) {
    Color color;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        break;

      case OrderStatus.confirmed:
        color = Colors.blueGrey;
        break;

      case OrderStatus.preparing:
        color = Colors.deepOrange;
        break;

      case OrderStatus.ready:
        color = Colors.purple;
        break;

      case OrderStatus.onTheWay:
        color = Colors.blue;
        break;

      case OrderStatus.delivered:
        color = Colors.green;
        break;

      case OrderStatus.cancelled:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        status.name
            .replaceAllMapped(
              RegExp(r'([A-Z])'),
              (match) => ' ${match.group(0)}',
            )
            .capitalizeFirst!,
        style: GoogleFonts.poppins(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
  //---------------------------------------------------
  // Button Text
  //---------------------------------------------------

  String _buttonText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
      case OrderStatus.preparing:
      case OrderStatus.ready:
      case OrderStatus.onTheWay:
        return "Track Order";

      case OrderStatus.delivered:
        return "View Details";

      case OrderStatus.cancelled:
        return "Reorder";
    }
  }
  //---------------------------------------------------
  // Date
  //---------------------------------------------------

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
