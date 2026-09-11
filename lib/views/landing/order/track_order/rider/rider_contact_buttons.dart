import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_colors.dart';

class RiderContactButtons extends StatelessWidget {
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const RiderContactButtons({
    super.key,
    this.onCall,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCall,
            icon: const FaIcon(
              FontAwesomeIcons.phone,
              size: 14,
            ),
            label: Text(
              'Call Rider',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primary,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: onMessage,
            icon: const FaIcon(
              FontAwesomeIcons.message,
              size: 14,
            ),
            label: Text(
              'Message',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}