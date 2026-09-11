// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class ProductSizeSelector extends StatelessWidget {
  final ProductModel product;
  final ProductVariantModel selectedVariant;
  final Function(ProductVariantModel) onVariantSelected;

  const ProductSizeSelector({
    super.key,
    required this.product,
    required this.selectedVariant,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Size",
          style: AppTextTheme.button,
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 12,
          children: product.variants.map((variant) {
            final bool isSelected = selectedVariant == variant;

            return GestureDetector(
              onTap: () => onVariantSelected(variant),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  variant.name,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
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