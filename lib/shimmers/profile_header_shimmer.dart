// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({super.key});

  Widget _box({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile image
        _box(
          width: 110,
          height: 110,
          radius: 55,
        ),

        const SizedBox(height: 20),

        // Name
        _box(
          width: 120,
          height: 18,
          radius: 7,
        ),

        const SizedBox(height: 8),

        // Email
        _box(
          width: 180,
          height: 14,
          radius: 6,
        ),

        const SizedBox(height: 10),

        // Edit profile button
        _box(
          width: 125,
          height: 42,
          radius: 100,
        ),
      ],
    );
  }
}