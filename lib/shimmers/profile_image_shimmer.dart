// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileImageShimmer extends StatelessWidget {
  const ProfileImageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: const CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
      ),
    );
  }
}