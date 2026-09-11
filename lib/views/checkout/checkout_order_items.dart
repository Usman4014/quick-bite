// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class CheckoutOrderItems extends StatelessWidget {
  CheckoutOrderItems({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Order (${cartController.totalProducts} Items)",
            style: AppTextTheme.textfieldtitleText,
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartController.cartItems.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 25, color: Colors.grey.shade300),
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    final bool isDeal = item.specialDeal != null;

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Image
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network(
                            isDeal
                                ? item.specialDeal!.squareImage
                                : item.product!.image,
                            fit: BoxFit.cover,

                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }

                              return Container(
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              );
                            },

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade100,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey.shade400,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 15),

                        /// Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isDeal
                                    ? item.specialDeal!.title
                                    : item.product!.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                isDeal
                                    ? "${item.specialDeal!.items.length} Items"
                                    : item.selectedVariant!.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                "Qty: ${item.quantity.value}",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Text(
                          "\$${item.totalPrice.toStringAsFixed(0)}",
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
