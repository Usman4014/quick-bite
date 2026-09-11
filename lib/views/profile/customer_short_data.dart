import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/shimmers/customer_short_data_shimmer.dart';

class CustomerShortData extends StatelessWidget {
  CustomerShortData({super.key});
  final ProductController productController = Get.find<ProductController>();
  final SpecialDealsController specialDealsController =
      Get.find<SpecialDealsController>();
  final ReviewController reviewController = Get.find<ReviewController>();
  final OrderController orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isLoading =
          orderController.isLoading.value ||
          productController.isLoading.value ||
          specialDealsController.isLoading.value ||
          reviewController.isLoading.value;

      if (isLoading) {
        return const CustomerShortDataShimmer();
      }

      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircleCheck,
                  color: AppColors.primary,
                  size: 15,
                ),
                const SizedBox(height: 2),

                Text('Orders', style: AppTextTheme.caption),
                const SizedBox(height: 2),

                Text(
                  orderController.completedOrders.length.toString(),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: AppColors.primary,
                  size: 15,
                ),
                const SizedBox(height: 2),

                Text('Favorites', style: AppTextTheme.caption),
                const SizedBox(height: 2),

                Text(
                  (productController.favoriteProducts.length +
                          specialDealsController.favoriteDeals.length)
                      .toString(),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidCircleCheck,
                  color: AppColors.primary,
                  size: 15,
                ),
                const SizedBox(height: 2),

                Text('Reviews', style: AppTextTheme.caption),
                const SizedBox(height: 2),

                Text(
                  reviewController.myTotalReviews.toString(),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),

            Column(
              children: [
                FaIcon(
                  FontAwesomeIcons.solidHeart,
                  color: AppColors.primary,
                  size: 15,
                ),
                const SizedBox(height: 2),

                Text('Saved', style: AppTextTheme.caption),
                const SizedBox(height: 2),

                Text(
                  '\$${orderController.totalSavedAmount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
