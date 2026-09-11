// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/shimmers/profile_header_shimmer.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final UserController userController =
        Get.find<UserController>();

    return Obx(() {
      final user = userController.currentUser.value;

      //==========================================================
      // USER DATA LOADING
      //==========================================================

      if (user == null) {
        return const ProfileHeaderShimmer();
      }

      //==========================================================
      // PROFILE IMAGE
      //==========================================================

      final String? profileImage = user.profileImage;

      final bool hasProfileImage =
          profileImage != null &&
          profileImage.trim().isNotEmpty;

      return Column(
        children: [
          //======================================================
          // PROFILE IMAGE
          //======================================================

          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.background,
                width: 2,
              ),
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(
                alpha: 0.1,
              ),
            ),
            child: hasProfileImage
                ? ClipOval(
                    child: Image.network(
                      profileImage,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,

                      loadingBuilder: (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      },

                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) {
                        return const Center(
                          child: FaIcon(
                            FontAwesomeIcons.user,
                            color: Colors.black,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.black,
                      size: 50,
                    ),
                  ),
          ),

          const SizedBox(height: 20),

          //======================================================
          // USER NAME
          //======================================================

          Text(
            user.name.trim().isNotEmpty
                ? user.name
                : 'No Name',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),

          //======================================================
          // USER EMAIL
          //======================================================

          Text(
            user.email.trim().isNotEmpty
                ? user.email
                : 'No Email',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          //======================================================
          // EDIT PROFILE BUTTON
          //======================================================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: SizedBox(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(
                    AppRoutes.editprofile,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.pen,
                  color: AppColors.primary,
                  size: 15,
                ),
                label: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}