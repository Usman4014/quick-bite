// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';

import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/models/Order_Model.dart';

import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

import 'package:quick_bite/views/landing/order/bottom_sheets/app_rating_bottomsheet.dart';
import 'package:quick_bite/views/landing/order/order_details/order_delivery_info.dart';
import 'package:quick_bite/views/landing/order/order_details/order_items_section.dart';
import 'package:quick_bite/views/landing/order/order_details/order_price_summary.dart';
import 'package:quick_bite/views/landing/order/order_status_badge.dart';

import 'package:quick_bite/widgets/back_button.dart';

class OrderDetailsScreen extends StatelessWidget {
  OrderDetailsScreen({super.key});

  final AppReviewController reviewController = Get.find<AppReviewController>();

  final LandingController landingController = Get.find<LandingController>();

  final OrderController orderController = Get.find<OrderController>();

  final AppSettingsController settingsController =
      Get.find<AppSettingsController>();

  @override
  Widget build(BuildContext context) {
    final OrderModel order = Get.arguments as OrderModel;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              App_Bar(),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      //================================================
                      // ORDER INFORMATION
                      //================================================

                      Container(
                        width: double.infinity,

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(15),

                          border: Border.all(color: Colors.grey.shade300),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    "Order ID",

                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),

                                  const SizedBox(height: 2),

                                  Text(
                                    order.orderId,

                                    style: GoogleFonts.poppins(
                                      color: AppColors.primary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today_rounded,
                                        size: 18,
                                        color: Colors.grey,
                                      ),

                                      const SizedBox(width: 8),

                                      Text(
                                        "${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}",

                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  Obx(() {
                                    final currentOrder = orderController
                                        .getOrderById(order.orderId);

                                    if (currentOrder == null) {
                                      return const SizedBox();
                                    }

                                    return OrderStatusBadge(
                                      status: currentOrder.status,
                                    );
                                  }),
                                ],
                              ),

                              SizedBox(
                                height: 150,
                                width: 150,

                                child: Image.asset(
                                  'assets/Track_Order/delivered.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      //================================================
                      // ITEMS
                      //================================================
                      OrderItemsSection(order: order),

                      const SizedBox(height: 30),

                      //================================================
                      // DELIVERY INFO
                      //================================================
                      OrderDeliveryInfo(order: order),

                      const SizedBox(height: 30),

                      //================================================
                      // PRICE SUMMARY
                      //================================================
                      OrderPriceSummary(order: order),

                      const SizedBox(height: 25),

                      //================================================
                      // CANCEL ORDER
                      //================================================
                      Obx(() {
                        final currentOrder = orderController.getOrderById(
                          order.orderId,
                        );

                        if (currentOrder == null) {
                          return const SizedBox();
                        }

                        //================================================
                        // CHECK ADMIN SETTING
                        //================================================

                        if (!settingsController.allowCancellation) {
                          return const SizedBox();
                        }

                        //================================================
                        // ONLY ALLOW CANCELLATION
                        // WHILE ORDER IS PENDING
                        //================================================

                        if (currentOrder.status != OrderStatus.pending) {
                          return const SizedBox();
                        }

                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 55,

                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showCancelConfirmation(
                                    context,
                                    currentOrder,
                                  );
                                },

                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 20,
                                ),

                                label: Text(
                                  "Cancel Order",

                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,

                                  side: const BorderSide(color: Colors.red),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),
                          ],
                        );
                      }),

                      //================================================
                      // DELIVERED ORDER ACTIONS
                      //================================================
                      Obx(() {
                        // Listen for order updates
                        orderController.orders.length;

                        final currentOrder = orderController.getOrderById(
                          order.orderId,
                        );

                        if (currentOrder == null) {
                          return const SizedBox();
                        }

                        // Only show after delivery
                        if (currentOrder.status != OrderStatus.delivered) {
                          return const SizedBox();
                        }

                        final alreadyRated = reviewController.hasMyReview;

                        return Column(
                          children: [
                            //================================================
                            // REORDER BUTTON
                            //================================================

                            SizedBox(
                              width: double.infinity,
                              height: 55,

                              child: ElevatedButton.icon(
                                onPressed: () {
                                  orderController.reorder(currentOrder);

                                  Get.back();

                                  landingController.changeTab(2);
                                },

                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  size: 20,
                                ),

                                label: Text(
                                  "Reorder",

                                  style: AppTextTheme.button,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            //================================================
                            // RATE BUTTON
                            //================================================
                            if (alreadyRated)
                              const SizedBox()
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 55,

                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.bottomSheet(
                                      AppRatingBottomSheet(),
                                      isScrollControlled: true,
                                    );
                                  },

                                  child: Text(
                                    "Rate Quick Bite",

                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),

                      const SizedBox(height: 35),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //============================================================
  // CANCEL CONFIRMATION DIALOG
  //============================================================

  void _showCancelConfirmation(BuildContext context, OrderModel order) {
    Get.dialog(
      AlertDialog(
        title: Text(
          "Cancel Order?",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),

        content: Text(
          "Are you sure you want to cancel this order?",
          style: GoogleFonts.poppins(),
        ),

        actions: [
          //======================================================
          // KEEP ORDER
          //======================================================

          TextButton(
            onPressed: () {
              Get.back();
            },

            child: Text(
              "No",
              style: GoogleFonts.poppins(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          //======================================================
          // CANCEL ORDER
          //======================================================
          TextButton(
            onPressed: () async {
              Get.back();

              await orderController.cancelOrder(order.orderId);
            },

            child: Text(
              "Yes, Cancel",
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget App_Bar() {
    return SafeArea(
      child: Row(
        children: [
          Back_Button(),

          const SizedBox(width: 15),

          Text('Order Details', style: AppTextTheme.appbarText),
        ],
      ),
    );
  }
}
