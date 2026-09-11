// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/shimmers/cart_shimmer.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/cart/cart_item_card.dart';
import 'package:quick_bite/views/landing/cart/cart_offer_card.dart';
import 'package:quick_bite/views/landing/cart/cart_summary.dart';
import 'package:quick_bite/views/landing/cart/checkout_button.dart';
import 'package:quick_bite/views/landing/cart/empty_cart.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            AppBar(),

            const SizedBox(height: 10),

            Expanded(
              child: Obx(() {
                //================================================
                // LOADING
                //================================================

                if (cartController.isLoading.value) {
                  return const CartShimmer();
                }

                //================================================
                // EMPTY CART
                //================================================

                if (cartController.cartItems.isEmpty) {
                  return EmptyCart();
                }

                //================================================
                // CART WITH ITEMS
                //================================================

                return Column(
                  children: [
                    //==============================================
                    // CART CONTENT
                    //==============================================

                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,

                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                          bottom: 30,
                        ),

                        physics: const BouncingScrollPhysics(),

                        // +3:
                        // 1 = Items title
                        // 1 = Cart Offer Card
                        // 1 = Cart Summary
                        itemCount: cartController.cartItems.length + 3,

                        separatorBuilder: (_, _) => const SizedBox(height: 15),

                        itemBuilder: (context, index) {
                          //================================================
                          // ITEMS TITLE
                          //================================================

                          if (index == 0) {
                            return Text(
                              '${cartController.totalProducts} Items',

                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }

                          //================================================
                          // CART ITEMS
                          //================================================

                          final cartItemIndex = index - 1;

                          if (cartItemIndex < cartController.cartItems.length) {
                            return CartItemCard(
                              cartItem: cartController.cartItems[cartItemIndex],
                            );
                          }

                          //================================================
                          // CART OFFER CARD
                          //================================================

                          if (cartItemIndex ==
                              cartController.cartItems.length) {
                            return CartOfferCard();
                          }

                          //================================================
                          // CART SUMMARY
                          //================================================

                          return const CartSummary();
                        },
                      ),
                    ),

                    //================================================
                    // CHECKOUT BUTTON
                    //================================================
                    CheckoutButton(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text('Cart', style: AppTextTheme.appbarText),

              Text(
                'Review your items before checkout',

                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
