// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/views/profile/customer_short_data.dart';
import 'package:quick_bite/views/profile/profile_header.dart';
import 'package:quick_bite/views/profile/profile_menu_title.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.primary,

      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Align(
                alignment: AlignmentGeometry.topCenter,
                child: ProfileHeader(),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: height * 0.6,
                  width: width,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 0),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            children: [
                              /// ===========================================
                              /// Number of ORDERS, FAVORITES, REVIEWS, SAVED
                              /// ===========================================
                              CustomerShortData(),

                              /// ===========================================
                              /// MY ADDRESS
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.locationDot,
                                title: "My Addresses",
                                onTap: () {
                                  Get.toNamed(AppRoutes.address);
                                },
                              ),

                              SizedBox(height: 12),

                              /// ===========================================
                              /// PAYMENT METHODS
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.wallet,
                                title: "Payment Methods",
                                onTap: () {
                                  Get.toNamed(AppRoutes.paymentMethod);
                                },
                              ),

                              SizedBox(height: 12),

                              /// ===========================================
                              /// MY FAVORITES
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.solidHeart,
                                title: "My Favorites",
                                onTap: () {
                                  Get.toNamed(AppRoutes.favorites);
                                },
                              ),

                              SizedBox(height: 12),

                              /// ===========================================
                              /// RATINGS & FEEDBACKS
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.solidStar,
                                title: "Ratings & Feedbacks",
                                onTap: () {
                                  Get.toNamed(AppRoutes.ratingsfeedbacks);
                                },
                              ),
                              SizedBox(height: 12),

                              /// ===========================================
                              /// PRIVACY POLICY
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.userShield,
                                title: "Privacy Policy",
                                onTap: () {
                                  Get.toNamed(AppRoutes.privacypolicy);
                                },
                              ),
                              SizedBox(height: 12),

                              /// ===========================================
                              /// CONTACT US
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.headset,
                                title: "Contact Us",
                                onTap: () {
                                  Get.toNamed(AppRoutes.contactus);
                                },
                              ),

                              SizedBox(height: 12),

                              /// ===========================================
                              /// ABOUT QUICKBITE
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.circleInfo,
                                title: "About Quick Bite",
                                onTap: () {
                                  Get.toNamed(AppRoutes.aboutquickbite);
                                },
                              ),

                              SizedBox(height: 12),

                              /// ===========================================
                              /// LOGOUT
                              /// ===========================================
                              ProfileMenuTile(
                                icon: FontAwesomeIcons.rightFromBracket,
                                title: "Log Out",
                                onTap: () {
                                  Get.defaultDialog(
                                    title: "Logout",
                                    titleStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                    middleText:
                                        "Are you sure you want to logout from your account?",
                                    middleTextStyle: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    radius: 20,
                                    textCancel: "Cancel",
                                    textConfirm: "Logout",
                                    cancelTextColor: Colors.black,
                                    confirmTextColor: Colors.black,
                                    buttonColor: AppColors.primary,
                                    onConfirm: () {
                                      userController.logout();
                                      Get.offAllNamed(AppRoutes.methodSelection);
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 12),
                              //          Padding(
                              //    padding: const EdgeInsets.only(bottom: 20),
                              //    child: LogoutButton(),
                              //  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
