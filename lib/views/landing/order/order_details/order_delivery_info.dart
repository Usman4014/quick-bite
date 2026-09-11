// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class OrderDeliveryInfo extends StatelessWidget {
  final OrderModel order;

  const OrderDeliveryInfo({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Delivery Address", style: AppTextTheme.textfieldtitleText),
          ],
        ),
        const SizedBox(height: 10),
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
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          FaIcon(
                            order.deliveryAddress.addressType.icon,
                            color: AppColors.primary,
                            size: 14,
                          ),
                          SizedBox(width: 7),
                          Text(
                            order.deliveryAddress.addressType.title,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
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
                order.deliveryAddress.neighborhood,
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
                  SizedBox(width: 8),
                  Text(
                    order.deliveryAddress.streetAddress,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade700,
                      //  height: 1.5,
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
                    '+1 ${order.deliveryAddress.phoneNumber}',
                    style: GoogleFonts.poppins(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
