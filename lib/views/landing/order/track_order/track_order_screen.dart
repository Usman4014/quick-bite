// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/order/order_details/order_timeline.dart';
import 'package:quick_bite/views/landing/order/order_status_badge.dart';
import 'package:quick_bite/views/landing/order/track_order/rider/rider_info_card.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/shimmers/track_order_shimmer.dart';

class TrackOrderScreen extends StatelessWidget {
  TrackOrderScreen({super.key});

  final OrderController orderController = Get.find<OrderController>();

  final FixedAssetController fixedAssetController =
      Get.find<FixedAssetController>();

  @override
  Widget build(BuildContext context) {
    final OrderModel argumentOrder = Get.arguments as OrderModel;
    final String orderId = argumentOrder.orderId;

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
                child: Obx(() {
                  final currentOrder = orderController.getOrderById(orderId);

                  if (orderController.isLoading.value || currentOrder == null) {
                    return const TrackOrderShimmer();
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //------------------------------------------------
                        // Order Info
                        //------------------------------------------------
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
                                      currentOrder.orderId,
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
                                          "${currentOrder.orderDate.day}/${currentOrder.orderDate.month}/${currentOrder.orderDate.year}",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    OrderStatusBadge(
                                      status: currentOrder.status,
                                    ),
                                  ],
                                ),

                                SizedBox(
                                  height: 150,
                                  width: 150,

                                  child: Obx(() {
                                    final String imageUrl = fixedAssetController
                                        .getImageUrl(
                                          getOrderStatusAssetId(
                                            currentOrder.status,
                                          ),
                                        );

                                    if (imageUrl.isEmpty) {
                                      return const Icon(
                                        Icons.delivery_dining_outlined,
                                        size: 70,
                                        color: Colors.black,
                                      );
                                    }

                                    return Image.network(
                                      imageUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.delivery_dining_outlined,
                                              size: 70,
                                              color: Colors.grey,
                                            );
                                          },
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        //------------------------------------------------
                        // Order Timeline
                        //------------------------------------------------
                        OrderTimeline(order: currentOrder),

                        const SizedBox(height: 20),

                        //------------------------------------------------
                        // Rider Information
                        //------------------------------------------------
                        Text(
                          "Your Rider",
                          style: AppTextTheme.textfieldtitleText,
                        ),

                        const SizedBox(height: 10),
                        if (currentOrder.rider != null) ...[
                          RiderInfoCard(rider: currentOrder.rider!),
                        ]
                        //------------------------------------------------
                        // No Rider Yet
                        //------------------------------------------------
                        else ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_pin_circle_rounded,
                                    color: AppColors.primary,
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Rider Information',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        'Your rider information will be available soon.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 25),

                        //------------------------------------------------
                        // Estimated Delivery
                        //------------------------------------------------
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Text(
                                "Estimated Delivery",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 13,
                                  // fontWeight: FontWeight.w600
                                ),
                              ),

                              Text(
                                currentOrder.estimatedDeliveryTime != null
                                    ? _formatEstimatedDelivery(
                                        currentOrder.estimatedDeliveryTime!,
                                      )
                                    : 'Calculating...',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        //------------------------------------------------
                        // Delivery Address
                        //------------------------------------------------
                        Text(
                          "Delivery Address",
                          style: AppTextTheme.textfieldtitleText,
                        ),

                        const SizedBox(height: 10),

                        Container(
                          padding: const EdgeInsets.all(18),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),

                                      child: Row(
                                        children: [
                                          FaIcon(
                                            currentOrder
                                                .deliveryAddress
                                                .addressType
                                                .icon,
                                            color: AppColors.primary,
                                            size: 14,
                                          ),

                                          const SizedBox(width: 7),

                                          Text(
                                            currentOrder
                                                .deliveryAddress
                                                .addressType
                                                .title,
                                            style: GoogleFonts.poppins(
                                              color: AppColors.primary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              Text(
                                currentOrder.deliveryAddress.neighborhood,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    color: AppColors.primary,
                                    size: 13,
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      currentOrder
                                          .deliveryAddress
                                          .streetAddress,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.phone,
                                    color: AppColors.primary,
                                    size: 13,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    '+1 ${currentOrder.deliveryAddress.phoneNumber}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //------------------------------------------------
  // App Bar
  //------------------------------------------------

  Widget App_Bar() {
    return SafeArea(
      child: Row(
        children: [
          Back_Button(),

          const SizedBox(width: 15),

          Text('Track Order', style: AppTextTheme.appbarText),
        ],
      ),
    );
  }

  //------------------------------------------------
  // Estimated Delivery
  //------------------------------------------------

  String _formatEstimatedDelivery(DateTime deliveryTime) {
    final now = DateTime.now();

    final difference = deliveryTime.difference(now);

    if (difference.inMinutes <= 0) {
      return 'Arriving soon';
    }

    return '${difference.inMinutes} minutes';
  }

  //------------------------------------------------
  // Order Status Image
  //------------------------------------------------

  String getOrderStatusAssetId(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'track_pending';

    case OrderStatus.confirmed:
      return 'track_confirmed';

    case OrderStatus.preparing:
      return 'track_preparing';

    case OrderStatus.ready:
      return 'track_ready';

    case OrderStatus.onTheWay:
      return 'track_on_the_way';

    case OrderStatus.delivered:
      return 'track_delivered';

    case OrderStatus.cancelled:
      return 'track_cancelled';
  }
}
}
