// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/privacypolicy/privacy_tile.dart';

import 'package:quick_bite/widgets/back_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Row(
              children: [
                AppBar(),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: .15),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.userShield,
                                color: AppColors.primary,
                                size: 28,
                              ),
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            "Your Privacy Matters",
                            style: AppTextTheme.titleText,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "We value your privacy and are committed to protecting your personal information while using Quick Bite.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    PrivacyTile(
                      icon: FontAwesomeIcons.userShield,
                      title: "Information We Collect",
                      description:
                          "We collect your name, phone number, email, delivery addresses and order history to provide our services.",
                    ),

                    const SizedBox(height: 15),

                    PrivacyTile(
                      icon: FontAwesomeIcons.burger,
                      title: "How We Use Your Information",
                      description:
                          "• Process your food orders\n"
                          "• Deliver your meals\n"
                          "• Improve app performance\n"
                          "• Provide customer support\n"
                          "• Send order updates",
                    ),

                    const SizedBox(height: 15),

                    PrivacyTile(
                      icon: FontAwesomeIcons.lock,
                      title: "Data Security",
                      description:
                          "Your information is stored securely. We never sell or share your personal information with third parties.",
                    ),

                    const SizedBox(height: 15),

                    PrivacyTile(
                      icon: FontAwesomeIcons.locationDot,
                      title: "Location Access",
                      description:
                          "Your location is only used to help deliver your orders accurately.",
                    ),

                    const SizedBox(height: 15),

                    PrivacyTile(
                      icon: FontAwesomeIcons.chartLine,
                      title: "Cookies & Analytics",
                      description:
                          "We may collect anonymous usage statistics to improve the performance and experience of Quick Bite.",
                    ),

                    const SizedBox(height: 15),

                    PrivacyTile(
                      icon: FontAwesomeIcons.rotate,
                      title: "Policy Updates",
                      description:
                          "Our Privacy Policy may change from time to time. Any updates will be reflected within the application.",
                    ),

                    const SizedBox(height: 15),

                    PrivacyTile(
                      icon: FontAwesomeIcons.envelope,
                      title: "Contact Us",
                      description:
                          "support@quickbite.com\n+1 352 473 9478",
                    ),

                    const SizedBox(height: 25),

                    Center(
                      child: Text(
                        "Last Updated\nAugust 2026",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),
            const SizedBox(width: 15),
            Text(
              "Privacy Policy",
              style: AppTextTheme.appbarText,
            ),
          ],
        ),
      ),
    );
  }
}

