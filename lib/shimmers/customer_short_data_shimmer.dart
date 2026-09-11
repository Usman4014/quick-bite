// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomerShortDataShimmer extends StatelessWidget {
  const CustomerShortDataShimmer({super.key});

  Widget _box({
    required double width,
    required double height,
    double radius = 6,
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

  Widget _item() {
    return Column(
      children: [
        _box(
          width: 16,
          height: 16,
          radius: 8,
        ),

        const SizedBox(height: 4),

        _box(
          width: 55,
          height: 11,
          radius: 5,
        ),

        const SizedBox(height: 4),

        _box(
          width: 30,
          height: 20,
          radius: 6,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(),
          _item(),
          _item(),
          _item(),
        ],
      ),
    );
  }
}