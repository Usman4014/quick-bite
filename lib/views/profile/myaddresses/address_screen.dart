// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/myaddresses/address_card.dart';
import 'package:quick_bite/views/profile/myaddresses/empty_address.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/shimmers/address_shimmer.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final AddressController addressController = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            AppBar(),

            const SizedBox(height: 20),

            //==================================================
            // ADDRESSES
            //==================================================
            Expanded(
              child: Obx(() {
                //================================================
                // LOADING
                //================================================

                if (addressController.isLoading.value) {
                  return const AddressShimmer();
                }

                //================================================
                // ERROR
                //================================================

                if (addressController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        addressController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                //================================================
                // EMPTY
                //================================================

                if (addressController.addresses.isEmpty) {
                  return EmptyAddress();
                }

                //================================================
                // ADDRESS LIST
                //================================================

                return Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 0,
                    bottom: 15,
                  ),
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: addressController.addresses.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 15),
                    itemBuilder: (_, index) {
                      return AddressCard(
                        address: addressController.addresses[index],
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

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Back_Button(),

                const SizedBox(width: 15),

                Text('My Addresses', style: AppTextTheme.appbarText),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.addaddress);

                // Get.toNamed(
                //   AppRoutes.selectLocationStreet,
                // );
              },
              child: Center(
                child: Text(
                  'Add',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
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
