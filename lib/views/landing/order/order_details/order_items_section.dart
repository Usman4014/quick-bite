// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class OrderItemsSection extends StatelessWidget {
  final OrderModel order;

  const OrderItemsSection({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Your Order (${order.items.length} Items)",
              style: AppTextTheme.textfieldtitleText,
            ),
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, _) => const Divider(height: 28),
            itemBuilder: (context, index) {
              final item = order.items[index];

              final bool isDeal = item.specialDeal != null;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //------------------------------------------------
                  // Image
                  //------------------------------------------------

                  Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                    
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        isDeal
                            ? item.specialDeal!.squareImage
                            : item.product!.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  //------------------------------------------------
                  // Details
                  //------------------------------------------------

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDeal
                              ? item.specialDeal!.title
                              : item.product!.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          isDeal
                              ? "${item.specialDeal!.items.length} Items Included"
                              : "Variant: ${item.variant!.name}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Qty: ${item.quantity}",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        if (!isDeal &&
                            item.notes != null &&
                            item.notes!.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),

                          Text(
                            "Note: ${item.notes}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  //------------------------------------------------
                  // Price
                  //------------------------------------------------

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$${item.totalPrice.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "\$${item.unitPrice.toStringAsFixed(2)} each",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}