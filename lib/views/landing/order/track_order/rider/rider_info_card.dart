// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/models/Rider_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';

class RiderInfoCard extends StatelessWidget {
  final RiderModel rider;

  const RiderInfoCard({super.key, required this.rider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Rider image
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.12),
            ),
            child: rider.profileImage.isEmpty
                ? Center(
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      color: AppColors.primary,
                      size: 26,
                    ),
                  )
                : Image.asset(rider.profileImage, fit: BoxFit.contain),
          ),

          const SizedBox(width: 14),

          // Rider information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rider.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 4),
                Row(
                  children: [
                    FaIcon(
                      FontAwesomeIcons.motorcycle,
                      size: 13,
                      color: Colors.grey.shade500,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${rider.vehicleType} • ${rider.vehicleNumber}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Rating
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.solidStar,
                      size: 11,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      rider.rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        // fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // Vehicle information
              ],
            ),
          ),
          SizedBox(
            height: 45,
            width: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(10),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              child: FaIcon(
                FontAwesomeIcons.phoneFlip,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
