// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WhyQuickBiteCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const WhyQuickBiteCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //========================================================
        // IMAGE FROM CLOUDINARY
        //========================================================

        SizedBox(
          height: 90,
          width: 90,
          child: imageUrl.isEmpty
              ? Icon(
                  Icons.image_outlined,
                  size: 55,
                  color: Colors.grey.shade300,
                )
              : Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Icon(
                      Icons.broken_image_outlined,
                      size: 55,
                      color: Colors.grey.shade300,
                    );
                  },
                ),
        ),

        const SizedBox(height: 12),

        //========================================================
        // TITLE
        //========================================================

        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        //========================================================
        // SUBTITLE
        //========================================================

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}