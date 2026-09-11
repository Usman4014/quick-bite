// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/order/order_card.dart';
import 'package:quick_bite/shimmers/orders_shimmer.dart';
import 'package:quick_bite/views/landing/order/order_empty.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,

        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              App_Bar(),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorAnimation: TabIndicatorAnimation.elastic,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashBorderRadius: BorderRadius.circular(30),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      // fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  dividerColor: Colors.transparent,
                  dividerHeight: 0,
                  indicator: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  tabs: [
                    Tab(child: Text('All Orders')),
                    Tab(child: Text('Ongoing')),
                    Tab(child: Text('Delivered')),
                    Tab(child: Text('Cancelled')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Obx(() {
                  if (orderController.isLoading.value) {
                    return const OrdersShimmer();
                  }

                  return TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // ALL ORDERS
                      _buildOrderList(orderController.orders),

                      // ONGOING ORDERS
                      _buildOrderList(orderController.ongoingOrders),

                      // DELIVERED ORDERS
                      _buildOrderList(orderController.completedOrders),

                      // CANCELLED ORDERS
                      _buildOrderList(orderController.canceledOrders),
                    ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Order', style: AppTextTheme.appbarText),
              Text(
                'Track and manage your orders',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List orders) {
    if (orders.isEmpty) {
      return OrderEmpty();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

      physics: const BouncingScrollPhysics(),

      itemCount: orders.length,

      itemBuilder: (context, index) {
        return OrderCard(order: orders[index]);
      },
    );
  }
}
