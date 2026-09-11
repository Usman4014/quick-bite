// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/helpers/cloudinary_image_helper.dart';
import 'package:quick_bite/models/Popular_Item_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_TextTheme.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class PopularItemCard extends StatelessWidget {
  final PopularItemModel item;
  final bool isHorizontal;

  const PopularItemCard({
    super.key,
    required this.item,
    this.isHorizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    final SpecialDealsController specialDealsController =
        Get.find<SpecialDealsController>();

    final ProductController productController = Get.find<ProductController>();

    final ReviewController reviewController = Get.find<ReviewController>();

    final double rating = reviewController.getAverageRatingForProduct(
      item.isSpecialDeal ? item.specialDeal!.id : item.product!.id,
    );

    return Padding(
      padding: EdgeInsets.only(
        left: isHorizontal ? 0 : 20,
        right: isHorizontal ? 15 : 20,
        bottom: 15,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          if (item.isSpecialDeal) {
            Get.toNamed(
              AppRoutes.specialDealDetails,
              arguments: item.specialDeal,
            );
          } else {
            Get.toNamed(
              AppRoutes.productdetailsscreen,
              arguments: item.product,
            );
          }
        },
        child: Container(
          width: isHorizontal
              ? MediaQuery.of(context).size.width - 40
              : double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 9),
                    child: Container(
                      height: isHorizontal ? 115 : 130,
                      width: isHorizontal ? 115 : 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        CloudinaryImageHelper.optimize(
                          item.isSpecialDeal
                              ? item.specialDeal!.squareImage
                              : item.image,
                          width: 260,
                          height: 260,
                        ),
                        width: isHorizontal ? 115 : 130,
                        height: isHorizontal ? 115 : 130,
                        fit: BoxFit.cover,
                        cacheWidth: 260,
                        cacheHeight: 260,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.fastfood_outlined, size: 35),
                          );
                        },
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    item.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: AppTextTheme.titleText,
                                  ),
                                ),
                              ),

                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    if (item.isSpecialDeal) {
                                      specialDealsController.toggleFavorite(
                                        item.specialDeal!,
                                      );

                                      Snack_Bar.show(
                                        title:
                                            item.specialDeal!.isFavorite.value
                                            ? "Added to Favorites"
                                            : "Removed from Favorites",
                                        message:
                                            "${item.specialDeal!.title} "
                                            "${item.specialDeal!.isFavorite.value ? 'has been added to' : 'has been removed from'} favorites",
                                        icon: item.specialDeal!.isFavorite.value
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart,
                                      );
                                    } else {
                                      productController.toggleFavorite(
                                        item.product!,
                                      );

                                      Snack_Bar.show(
                                        title: item.product!.isFavorite.value
                                            ? "Added to Favorites"
                                            : "Removed from Favorites",
                                        message:
                                            "${item.product!.name} "
                                            "${item.product!.isFavorite.value ? 'has been added to' : 'has been removed from'} favorites",
                                        icon: item.product!.isFavorite.value
                                            ? FontAwesomeIcons.solidHeart
                                            : FontAwesomeIcons.heart,
                                      );
                                    }
                                  },
                                  child: Center(
                                    child: FaIcon(
                                      item.isSpecialDeal
                                          ? (item.specialDeal!.isFavorite.value
                                                ? FontAwesomeIcons.solidHeart
                                                : FontAwesomeIcons.heart)
                                          : (item.product!.isFavorite.value
                                                ? FontAwesomeIcons.solidHeart
                                                : FontAwesomeIcons.heart),
                                      color: item.isSpecialDeal
                                          ? (item.specialDeal!.isFavorite.value
                                                ? AppColors.primary
                                                : Colors.grey.shade400)
                                          : (item.product!.isFavorite.value
                                                ? AppColors.primary
                                                : Colors.grey.shade400),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            item.isSpecialDeal
                                ? item.specialDeal!.description
                                : item.product!.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: AppTextTheme.caption,
                          ),

                          const SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),

                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.solidStar,
                                    size: 12,
                                    color: AppColors.primary,
                                  ),

                                  const SizedBox(width: 3),

                                  Text(rating.toStringAsFixed(1)),
                                ],
                              ),

                              SizedBox(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (item.isSpecialDeal) {
                                      Get.toNamed(
                                        AppRoutes.specialDealDetails,
                                        arguments: item.specialDeal,
                                      );
                                    } else {
                                      Get.toNamed(
                                        AppRoutes.productdetailsscreen,
                                        arguments: item.product,
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.add, size: 18),
                                  label: Text(
                                    "Add",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
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

              if (item.isSpecialDeal)
                Positioned(
                  top: 10,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 3,
                      ),
                      child: Text(
                        'Special Deal',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
