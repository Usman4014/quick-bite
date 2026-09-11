// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PaymentMethodShimmer extends StatelessWidget {
  const PaymentMethodShimmer({super.key});

  Widget _box({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _card() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Card icon
              _box(
                width: 48,
                height: 34,
                radius: 6,
              ),

              const SizedBox(width: 14),

              // Card name
              Expanded(
                child: _box(
                  width: double.infinity,
                  height: 16,
                ),
              ),

              const SizedBox(width: 12),

              // More button
              _box(
                width: 32,
                height: 32,
                radius: 16,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Card number
          _box(
            width: 210,
            height: 15,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // Expiry
              _box(
                width: 75,
                height: 13,
              ),

              const SizedBox(width: 20),

              // Card holder
              _box(
                width: 120,
                height: 13,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Default badge
          _box(
            width: 80,
            height: 28,
            radius: 14,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 15,
        ),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, _) =>
              const SizedBox(height: 15),
          itemBuilder: (_, index) {
            return _card();
          },
        ),
      ),
    );
  }
}