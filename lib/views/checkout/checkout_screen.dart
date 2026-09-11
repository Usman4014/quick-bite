// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';

import 'package:quick_bite/routes/App_Routes.dart';

import 'package:quick_bite/shimmers/checkout_shimmer.dart';

import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

import 'package:quick_bite/views/checkout/checkout_address_card.dart';
import 'package:quick_bite/views/checkout/checkout_note_card.dart';
import 'package:quick_bite/views/checkout/checkout_order_items.dart';
import 'package:quick_bite/views/checkout/checkout_payment_card.dart';
import 'package:quick_bite/views/checkout/checkout_promo_card.dart';
import 'package:quick_bite/views/checkout/checkout_summary.dart';

import 'package:quick_bite/widgets/back_button.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  //============================================================
  // CONTROLLERS
  //============================================================

  final CartController cartController =
      Get.find<CartController>();

  final OrderController orderController =
      Get.find<OrderController>();

  final AppSettingsController settingsController =
      Get.find<AppSettingsController>();

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      //========================================================
      // PLACE ORDER BUTTON
      //========================================================

      bottomNavigationBar: Obx(() {
        //======================================================
        // LOADING BUTTON
        //======================================================

        if (cartController.isLoading.value ||
            settingsController.isLoading.value) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              10,
              20,
              20,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: AppConstants.buttonHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          );
        }

        //======================================================
        // NORMAL BUTTON
        //======================================================

        final bool canPlaceOrders =
            settingsController.canPlaceOrders;

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            20,
          ),

          child: SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight,

            child: ElevatedButton(
              //================================================
              // BUTTON ACTION
              //================================================

              onPressed: canPlaceOrders
                  ? () async {
                      final success =
                          await orderController.placeOrder();

                      if (success) {
                        Get.offNamed(
                          AppRoutes.orderSuccess,
                          arguments:
                              orderController.lastOrder.value,
                        );
                      }
                    }
                  : null,

              //================================================
              // BUTTON CONTENT
              //================================================

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  Text(
                    canPlaceOrders
                        ? "Place Order"
                        : "Orders Unavailable",

                    style: AppTextTheme.titleText,
                  ),

                  if (canPlaceOrders)
                    Text(
                      "Total: \$${cartController.totalAmount.toStringAsFixed(2)}",

                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }),

      //========================================================
      // BODY
      //========================================================

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            App_Bar(),

            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                //================================================
                // CHECKOUT LOADING
                //================================================

                if (cartController.isLoading.value ||
                    settingsController.isLoading.value) {
                  return const CheckoutShimmer();
                }

                //================================================
                // NORMAL CHECKOUT
                //================================================

                return SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),

                  child: Column(
                    children: [
                      //================================================
                      // ORDER AVAILABILITY MESSAGE
                      //================================================

                      Obx(() {
                        if (settingsController
                            .canPlaceOrders) {
                          return const SizedBox.shrink();
                        }

                        return Container(
                          width: double.infinity,

                          padding:
                              const EdgeInsets.all(15),

                          margin:
                              const EdgeInsets.only(
                            bottom: 25,
                          ),

                          decoration:
                              BoxDecoration(
                            color: Colors.red.withValues(
                              alpha: 0.08,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),

                            border:
                                Border.all(
                              color:
                                  Colors.red.withValues(
                                alpha: 0.20,
                              ),
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              const Icon(
                                Icons
                                    .info_outline_rounded,
                                color: Colors.red,
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Orders are currently unavailable",

                                      style:
                                          GoogleFonts
                                              .poppins(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            Colors.red,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      "The restaurant is not accepting new orders right now. Please try again later.",

                                      style:
                                          GoogleFonts
                                              .poppins(
                                        fontSize: 12,
                                        color:
                                            Colors.grey
                                                .shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      //================================================
                      // DELIVERY ADDRESS
                      //================================================

                      CheckoutAddressCard(),

                      const SizedBox(
                        height: 30,
                      ),

                      //================================================
                      // PAYMENT METHOD
                      //================================================

                      CheckoutPaymentCard(),

                      const SizedBox(
                        height: 30,
                      ),

                      //================================================
                      // CHECKOUT ITEMS
                      //================================================

                      CheckoutOrderItems(),

                      const SizedBox(
                        height: 30,
                      ),

                      //================================================
                      // PROMO CODE
                      //================================================

                      CheckoutPromoCard(),

                      const SizedBox(
                        height: 30,
                      ),

                      //================================================
                      // ORDER NOTE
                      //================================================

                      CheckoutNoteCard(),

                      const SizedBox(
                        height: 30,
                      ),

                      //================================================
                      // ORDER SUMMARY
                      //================================================

                      CheckoutSummary(),

                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
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

  Widget App_Bar() {
    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 20,
        ),

        child: Row(
          children: [
            Back_Button(),

            const SizedBox(
              width: 15,
            ),

            Text(
              'Checkout',
              style: AppTextTheme.appbarText,
            ),
          ],
        ),
      ),
    );
  }
}