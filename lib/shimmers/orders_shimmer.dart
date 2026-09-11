// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrdersShimmer extends StatelessWidget {
  const OrdersShimmer({super.key});

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 12,
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

  Widget _orderCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _shimmerBox(
                width: 55,
                height: 55,
                radius: 14,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      width: 130,
                      height: 14,
                      radius: 6,
                    ),
                    const SizedBox(height: 8),
                    _shimmerBox(
                      width: 90,
                      height: 11,
                      radius: 5,
                    ),
                  ],
                ),
              ),
              _shimmerBox(
                width: 65,
                height: 25,
                radius: 20,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _shimmerBox(
            width: double.infinity,
            height: 12,
            radius: 6,
          ),

          const SizedBox(height: 8),

          _shimmerBox(
            width: 180,
            height: 12,
            radius: 6,
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _shimmerBox(
                  width: double.infinity,
                  height: 12,
                  radius: 6,
                ),
              ),
              const SizedBox(width: 20),
              _shimmerBox(
                width: 70,
                height: 14,
                radius: 6,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      physics: const BouncingScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _orderCard();
      },
    );
  }
}