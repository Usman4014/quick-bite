// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/PaymentMethod_Controller.dart';

import 'package:quick_bite/models/PaymentMethod_Model.dart';

import 'package:quick_bite/routes/App_Routes.dart';

import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

import 'payment_method_tile.dart';

class CheckoutPaymentCard extends StatelessWidget {
  CheckoutPaymentCard({super.key});

  final PaymentMethodController paymentController =
      Get.find<PaymentMethodController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool cashOnDeliveryEnabled =
          paymentController.isCashOnDeliveryEnabled;

      final bool onlinePaymentEnabled =
          paymentController.isOnlinePaymentEnabled;

      final List<PaymentMethodModel> savedCards =
          paymentController.paymentMethods;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //======================================================
          // TITLE
          //======================================================

          Text("Payment Method", style: AppTextTheme.textfieldtitleText),

          const SizedBox(height: 5),

          //======================================================
          // PAYMENT CARD
          //======================================================
          Container(
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(15),

              border: Border.all(color: Colors.grey.shade300),
            ),

            child: Column(
              children: [
                //================================================
                // CASH ON DELIVERY
                //================================================

                if (cashOnDeliveryEnabled)
                  PaymentMethodTile(
                    leading: const FaIcon(
                      FontAwesomeIcons.moneyBillWave,
                      color: AppColors.primary,
                    ),

                    title: "Cash on Delivery",

                    subtitle: "Pay when your order arrives",

                    isSelected: paymentController.paymentMethods.every(
                      (card) => !card.isSelected,
                    ),

                    onTap: () {
                      paymentController.selectCashOnDelivery();
                    },
                  ),

                //================================================
                // ONLINE PAYMENT
                //================================================
                if (onlinePaymentEnabled)
                  ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: savedCards.length,

                    itemBuilder: (context, index) {
                      final PaymentMethodModel card = savedCards[index];

                      final String cardNumber = card.cardNumber ?? '';

                      final String lastFour = cardNumber.length >= 4
                          ? cardNumber.substring(cardNumber.length - 4)
                          : cardNumber;

                      return PaymentMethodTile(
                        leading: SizedBox(
                          height: 40,
                          width: 40,

                          child: Image.asset(
                            card.title == 'MasterCard'
                                ? 'assets/Visa_MasterCard_Credit_Debit/mastercard.png'
                                : card.title == 'Visa'
                                ? 'assets/Visa_MasterCard_Credit_Debit/visa.png'
                                : 'assets/Visa_MasterCard_Credit_Debit/credit_debit.png',
                          ),
                        ),

                        title: card.title,

                        subtitle: "**** **** **** $lastFour",

                        isSelected: card.isSelected,

                        onTap: () {
                          paymentController.selectPaymentMethod(card);
                        },
                      );
                    },
                  ),

                //================================================
                // NO PAYMENT METHOD AVAILABLE
                //================================================
                if (!cashOnDeliveryEnabled && !onlinePaymentEnabled)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,

                          color: Colors.red,
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Text(
                            "No payment methods are currently available.",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                //================================================
                // MANAGE CARDS
                //================================================
                if (onlinePaymentEnabled) const SizedBox(height: 5),

                if (onlinePaymentEnabled)
                  Align(
                    alignment: Alignment.centerRight,

                    child: TextButton.icon(
                      onPressed: () {
                        Get.toNamed(AppRoutes.paymentMethod);
                      },

                      icon: const FaIcon(
                        FontAwesomeIcons.plus,

                        size: 14,

                        color: AppColors.primary,
                      ),

                      label: Text(
                        "Manage Cards",

                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,

                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
