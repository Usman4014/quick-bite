// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final FaIconData icon;
  final String title;
  final VoidCallback? onTap;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
       
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
         
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              /// Leading Icon
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: FaIcon(
                    icon,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
              ),
          
              const SizedBox(width: 15),
          
              /// Title
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
          
              /// Arrow
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FaIcon(FontAwesomeIcons.chevronRight,color:AppColors.primary,size:20),
            )
            ],
          ),
        ),
      ),
    );
  }
}