// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_colors.dart';

class PaymentMethodTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .08)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            leading,

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ]
                ],
              ),
            ),

            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.primary,
                size: 20,
              )
          ],
        ),
      ),
    );
  }
}