// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen>
    with SingleTickerProviderStateMixin {
  late OrderModel order;
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    order = Get.arguments;

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    scaleAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Column(
            children: [
              const Spacer(),

              ScaleTransition(
                scale: scaleAnimation,

                child: Container(
                  height: 120,
                  width: 120,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.check_rounded,
                    size: 70,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "Order Placed!",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Your delicious food is being prepared.\nWe will deliver it to you soon.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Order ID: ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                     // fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Text(
                    order.orderId,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // Order Information Card
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(15),

                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: Column(
                  children: [
                    _infoRow(Icons.receipt_long, "Order Status", "Preparing"),

                    const Divider(height: 25),

                    _infoRow(
                      Icons.timer_outlined,
                      "Estimated Delivery",
                      "45 Minutes",
                    ),

                    const Divider(height: 25),

                    _infoRow(
                      Icons.local_shipping_outlined,
                      "Delivery",
                      "On the way soon",
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  onPressed: () {
                    final landingController = Get.find<LandingController>();

                    landingController.changeTab(1);

                    Get.until(
                      (route) => route.settings.name == AppRoutes.landing,
                    );
                  },

                  child: Text(
                    "Track My Order",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: OutlinedButton(
                  onPressed: () {
                    final landingController = Get.find<LandingController>();

                    landingController.changeTab(0);

                    Get.until(
                      (route) => route.settings.name == AppRoutes.landing,
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  child: Text(
                    "Continue Shopping",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,

          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),

            borderRadius: BorderRadius.circular(100),
          ),

          child: Icon(icon, color: AppColors.primary, size: 22),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),

              Text(
                value,

                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
