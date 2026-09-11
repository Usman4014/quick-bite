// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/shimmers/payment_method_shimmer.dart';
import 'package:quick_bite/controllers/PaymentMethod_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';

import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/paymentmethods/empty_payment_method.dart';
import 'package:quick_bite/views/profile/paymentmethods/payment_method_card.dart';

import 'package:quick_bite/widgets/back_button.dart';

class PaymentMethod_Screen extends StatelessWidget {
  PaymentMethod_Screen({super.key});

  final PaymentMethodController paymentController =
      Get.find<PaymentMethodController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            AppBar(context),

            const SizedBox(height: 20),

            Expanded(
              child: Obx(() {
                //==========================================================
                // USER DATA LOADING
                //==========================================================

                if (paymentController.userController.currentUser.value ==
                    null) {
                  return const PaymentMethodShimmer();
                }

                //==========================================================
                // EMPTY
                //==========================================================

                if (paymentController.paymentMethods.isEmpty) {
                  return EmptyPaymentMethod();
                }

                //==========================================================
                // PAYMENT METHODS
                //==========================================================

                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 0,
                    bottom: 15,
                  ),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: paymentController.paymentMethods.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 15),
                    itemBuilder: (_, index) {
                      return PaymentMethodCard(
                        paymentMethod: paymentController.paymentMethods[index],
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget AppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Back_Button(),
                SizedBox(width: 15),
                Text('Payment Methods', style: AppTextTheme.appbarText),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.addcreditdebitcard);
              },
              child: Center(
                child: Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
