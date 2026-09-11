// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/profile/contactus/contact_tile.dart';

import 'package:quick_bite/views/profile/social_button.dart';
import 'package:quick_bite/widgets/back_button.dart';


class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
                AppBarWidget(),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    /// Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withValues(alpha: .15),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: FaIcon(
                                FontAwesomeIcons.headset,
                                color: AppColors.primary,
                                size: 34,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            "We're Here to Help",
                            style: AppTextTheme.titleText,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Have a question, suggestion or need assistance?\nOur team is always happy to help.",
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

                    Contact_Tile(
                      icon: FontAwesomeIcons.envelope,
                      title: "Email",
                      subtitle: "support@quickbite.com",
                    ),

                    const SizedBox(height: 15),

                    Contact_Tile(
                      icon: FontAwesomeIcons.phone,
                      title: "Phone",
                      subtitle: "+92 300 1234567", 
                    ),

                    const SizedBox(height: 15),

                    Contact_Tile(
                      icon: FontAwesomeIcons.comments,
                      title: "Live Chat",
                      subtitle: "Available 9:00 AM - 11:00 PM",
                    ),

                    const SizedBox(height: 15),

                    Contact_Tile(
                      icon: FontAwesomeIcons.locationDot,
                      title: "Office",
                      subtitle:
                          "Quick Bite Headquarters\nIslamabad, Pakistan",
                    ),

                    const SizedBox(height: 25),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Follow Us",
                        style: AppTextTheme.titleText,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        SocialButton(icon: FontAwesomeIcons.facebookF),
                        SocialButton(icon: FontAwesomeIcons.instagram),
                        SocialButton(icon: FontAwesomeIcons.xTwitter),
                        SocialButton(icon: FontAwesomeIcons.linkedinIn),
                      ],
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Send Message",
                          style: AppTextTheme.button,
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

  Widget AppBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Back_Button(),
          const SizedBox(width: 15),
          Text(
            "Contact Us",
            style: AppTextTheme.appbarText,
          ),
        ],
      ),
    );
  }
}

