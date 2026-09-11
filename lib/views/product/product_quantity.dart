// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class ProductQuantity extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const ProductQuantity({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quantity",
          style: AppTextTheme.button,
        ),

        const SizedBox(height: 15),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onDecrease,
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.primary,
                    child: FaIcon(
                      FontAwesomeIcons.minus,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                Text(
                  quantity.toString(),
                  style: AppTextTheme.appbarText,
                ),

                const SizedBox(width: 20),

                GestureDetector(
                  onTap: onIncrease,
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: AppColors.primary,
                    child: FaIcon(
                      FontAwesomeIcons.plus,
                      color: Colors.black,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        Container(
          height: 1.5,
          width: double.infinity,
          color: Colors.grey.shade200,
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}