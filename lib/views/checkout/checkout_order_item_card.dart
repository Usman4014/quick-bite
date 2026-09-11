// ignore_for_file: avoid_print, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class CheckoutOrderItemCard extends StatelessWidget {
  const CheckoutOrderItemCard({super.key, required this.cartItem});

  final CartItemModel cartItem;

  @override
  Widget build(BuildContext context) {
    final bool isDeal = cartItem.specialDeal != null;
    final double totalPrice = cartItem.totalPrice;

    //============================================================
    // IMAGE URL
    //============================================================

    final String imageUrl = isDeal
        ? cartItem.specialDeal!.bannerImage
        : cartItem.product!.image;

    print('CHECKOUT IMAGE URL: $imageUrl');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //========================================================
        // PRODUCT / DEAL IMAGE
        //========================================================

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade100,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey.shade400,
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 15),

        //========================================================
        // PRODUCT DETAILS
        //========================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDeal ? cartItem.specialDeal!.title : cartItem.product!.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                isDeal
                    ? "${cartItem.specialDeal!.items.length} Items"
                    : cartItem.selectedVariant!.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Qty: ${cartItem.quantity.value}",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "\$${totalPrice.toStringAsFixed(0)}",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
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
