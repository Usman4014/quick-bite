// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class FavoriteSpecialDealCard extends StatelessWidget {
  final SpecialDealsModel deal;

  FavoriteSpecialDealCard({
    super.key,
    required this.deal,
  });

  final SpecialDealsController specialDealsController =
      Get.find<SpecialDealsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Get.toNamed(
            AppRoutes.specialDealDetails,
            arguments: deal,
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              /// Deal Image
              Padding(
                padding: const EdgeInsets.only(left: 9),
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      deal.squareImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      /// Title + Favorite
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 15),
                              child: Text(
                                deal.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextTheme.titleText,
                              ),
                            ),
                          ),
      
                          GestureDetector(
                            onTap: () {
                              specialDealsController.toggleFavorite(deal);
      
                              Snack_Bar.show(
                                title: deal.isFavorite.value
                                    ? "Added to Favorites"
                                    : "Removed from Favorites",
                                message: deal.isFavorite.value
                                    ? "${deal.title} has been added to favorites"
                                    : "${deal.title} has been removed from favorites",
                                icon: deal.isFavorite.value
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                              );
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Center(
                                child: Obx(
                                  () => FaIcon(
                                    deal.isFavorite.value
                                        ? FontAwesomeIcons
                                            .solidHeart
                                        : FontAwesomeIcons
                                            .heart,
                                    color: deal.isFavorite.value
                                        ? AppColors.primary
                                        : Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
      
                      const SizedBox(height: 8),
      
                      /// Description
                      Text(
                        deal.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextTheme.bodyText,
                      ),
      
                      const SizedBox(height: 10),
      
                      /// Discount Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          deal.discount,
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
      
                      const SizedBox(height: 12),
      
                      /// Price + View Button
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "\$${deal.dealPrice.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
      
                              const SizedBox(width: 8),
      
                              Text(
                                "\$${deal.originalPrice.toStringAsFixed(2)}",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  decoration:
                                      TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
      
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: Text(
                                "View",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}