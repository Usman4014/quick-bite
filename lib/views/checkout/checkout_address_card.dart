// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class CheckoutAddressCard extends StatelessWidget {
  CheckoutAddressCard({super.key});

  final AddressController addressController = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedAddress = addressController.selectedAddress;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Delivery Address", style: AppTextTheme.textfieldtitleText),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: selectedAddress == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),

                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.location_off_outlined,
                              color: Colors.grey.shade300,
                              size: 50,
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "No delivery address added",
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade500,
                               // fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 15),

                            ElevatedButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.address);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: Text(
                                "Add Address",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  FaIcon(
                                    selectedAddress.addressType.icon,
                                    color: AppColors.primary,
                                    size: 14,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    selectedAddress.addressType.title,
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                
                          InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.address);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.pen,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                
                      const SizedBox(height: 15),
                
                      Text(
                        selectedAddress.neighborhood,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                
                      const SizedBox(height: 6),
                
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: AppColors.primary,
                            size: 13,
                          ),
                          SizedBox(width: 8),
                          Text(
                            
                            selectedAddress.streetAddress,
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade700,
                              //  height: 1.5,
                            ),
                          ),
                        ],
                      ),
                
                      const SizedBox(height: 6),
                
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.phone,
                            color: AppColors.primary,
                            size: 13,
                          ),
                          
                
                          const SizedBox(width: 8),
                
                          Text(
                            '+1 ${selectedAddress.phoneNumber}',
                            style: GoogleFonts.poppins(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      );
    });
  }
}
