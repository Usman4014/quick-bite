// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/widgets/snack_bar.dart';
import 'package:shimmer/shimmer.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel cartItem;

  CartItemCard({
    super.key,
    required this.cartItem,
  });

  final CartController cartController =
      Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    //============================================================
    // PRODUCT / DEAL IMAGE
    //============================================================

    final String imageUrl =
        cartItem.product?.image ??
        cartItem.specialDeal!.squareImage;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [

            //======================================================
            // PRODUCT / DEAL IMAGE
            //======================================================

            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  //================================================
                  // LOADING → SHIMMER
                  //================================================

                  loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                  ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 90,
                        width: 90,
                        color: Colors.white,
                      ),
                    );
                  },

                  //================================================
                  // ERROR
                  //================================================

                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
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
            ),

            const SizedBox(width: 15),

            //======================================================
            // PRODUCT DETAILS
            //======================================================

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  //================================================
                  // NAME + DELETE
                  //================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 23),
                          child: Text(
                            cartItem.product?.name ??
                                cartItem.specialDeal!.title,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style:
                                GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          cartController
                              .removeFromCart(
                            cartItem,
                          );

                          Snack_Bar.show(
                            title: 'Removed from cart',
                            message:
                                '${cartItem.product?.name ?? cartItem.specialDeal!.title} has been removed from cart',
                            icon: FontAwesomeIcons
                                .cartArrowDown,
                          );
                        },
                        child: FaIcon(
                          FontAwesomeIcons.trashCan,
                          size: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  //================================================
                  // VARIANT / SPECIAL DEAL
                  //================================================

                  Text(
                    cartItem.product != null
                        ? cartItem.selectedVariant!.name
                        : 'Special Deal',
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 15),

                  //================================================
                  // PRICE + QUANTITY
                  //================================================

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      //================================================
                      // PRICE
                      //================================================

                      Obx(
                        () => Text(
                          '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                          style:
                              GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                      ),

                      //================================================
                      // QUANTITY CONTROLS
                      //================================================

                      Row(
                        children: [

                          //============================================
                          // MINUS
                          //============================================

                          GestureDetector(
                            onTap: () {
                              cartController
                                  .decreaseQuantity(
                                cartItem,
                              );
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  AppColors.primary,
                              child: const FaIcon(
                                FontAwesomeIcons.minus,
                                size: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          //============================================
                          // QUANTITY
                          //============================================

                          Obx(
                            () => Text(
                              cartItem.quantity.value
                                  .toString(),
                              style:
                                  GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 15),

                          //============================================
                          // PLUS
                          //============================================

                          GestureDetector(
                            onTap: () {
                              cartController
                                  .increaseQuantity(
                                cartItem,
                              );
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  AppColors.primary,
                              child: const FaIcon(
                                FontAwesomeIcons.plus,
                                size: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}