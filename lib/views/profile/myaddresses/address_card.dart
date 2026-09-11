// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/App_TextTheme.dart';
import 'package:quick_bite/theme/app_colors.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  AddressCard({super.key, required this.address});

  final AddressController addressController = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        addressController.selectAddress(address);
      },
      child: Container(
        decoration: BoxDecoration(
          color: address.isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: address.isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
            width: address.isSelected ? 2 : 1,
          ),
        ),

        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 0, bottom: 15),
          child: Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: FaIcon(
                    address.addressType.icon,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.addressType.title,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: AppColors.primary,

                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (address.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              "✓ Default",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          color: Colors.white,
                          constraints: const BoxConstraints(),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          icon: const FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            size: 18,
                            color: Colors.black,
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                Get.toNamed(
                                  AppRoutes.addaddress,
                                  arguments: address,
                                );
                                break;

                              case 'default':
                                addressController.setDefaultAddress(address);
                                break;

                              case 'delete':
                                addressController.removeAddress(address);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.pen,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 12),
                                  Text('Edit'),
                                ],
                              ),
                            ),

                            if (!address.isDefault)
                              const PopupMenuItem(
                                value: 'default',
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.solidCircleCheck,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Set as Default'),
                                  ],
                                ),
                              ),

                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.trash,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 12),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 5),
                    Text(address.neighborhood, style: AppTextTheme.button),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 13,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              maxLines: 1,overflow: TextOverflow.ellipsis,
                              address.streetAddress,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: address.isSelected
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.phone,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 7),
                            Text(
                              '+1 ${address.phoneNumber}',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  //fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FaIcon(
                            address.isSelected
                                ? FontAwesomeIcons.solidCircleCheck
                                : FontAwesomeIcons.circleCheck,
                            color: address.isSelected
                                ? AppColors.primary
                                : Colors.grey.shade400,
                            size: 17,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
