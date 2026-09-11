// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:quick_bite/enums/Offer_Discount_Type.dart';
import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_Colors.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback onPressed;

  const OfferCard({super.key, required this.offer, required this.onPressed});

  //============================================================
  // DISCOUNT TEXT
  //============================================================

  String get discountText {
    switch (offer.discountType) {
      case OfferDiscountType.percentage:
        return "${offer.discountValue.toInt()}% OFF";

      case OfferDiscountType.flat:
        return "\$${offer.discountValue.toInt()} OFF";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        Get.toNamed(AppRoutes.offerDetails, arguments: offer);
      },

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(15),

          border: Border.all(color: Colors.grey.shade300),
        ),

        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),

              child: Row(
                children: [
                  //==================================================
                  // CLOUDINARY SQUARE IMAGE
                  //==================================================

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),

                    child: Image.network(
                      offer.squareImage,

                      width: 110,
                      height: 110,

                      fit: BoxFit.cover,

                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Container(
                          width: 110,
                          height: 110,

                          color: Colors.grey.shade100,

                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },

                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 110,
                          height: 110,

                          color: Colors.grey.shade100,

                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              size: 35,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  //==================================================
                  // CONTENT
                  //==================================================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(
                              child: Text(
                                offer.title,

                                maxLines: 1,

                                overflow: TextOverflow.ellipsis,

                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,

                                borderRadius: BorderRadius.circular(100),
                              ),

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),

                                child: Text(
                                  discountText,

                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Text(
                          offer.description,

                          maxLines: 2,

                          overflow: TextOverflow.ellipsis,

                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,

                              size: 14,

                              color: Colors.grey.shade500,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              "Min \$${offer.minimumOrderAmount.toInt()}",

                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Text(
                              'Till: ${DateFormat("MMM dd, yyyy").format(offer.endDate)}',

                              style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 11,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              "View",

                              style: GoogleFonts.poppins(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(width: 4),

                            const Icon(
                              Icons.arrow_forward_ios,

                              size: 12,

                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //========================================================
            // GIFT ICON
            //========================================================
            Positioned(
              top: 8,
              left: 8,

              child: Container(
                height: 30,
                width: 30,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: Colors.white,

                  border: Border.all(color: Colors.grey.shade200),
                ),

                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.gift,

                    color: AppColors.primary,

                    size: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
