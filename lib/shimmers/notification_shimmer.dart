import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({super.key});

  Widget _box({
    required double width,
    required double height,
    double radius = 10,
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

  Widget _notificationItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(
            width: 52,
            height: 52,
            radius: 26,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(
                  width: 150,
                  height: 15,
                  radius: 6,
                ),

                const SizedBox(height: 8),

                _box(
                  width: double.infinity,
                  height: 12,
                  radius: 6,
                ),

                const SizedBox(height: 6),

                _box(
                  width: 220,
                  height: 12,
                  radius: 6,
                ),

                const SizedBox(height: 8),

                _box(
                  width: 75,
                  height: 10,
                  radius: 5,
                ),
              ],
            ),
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
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _notificationItem();
        },
      ),
    );
  }
}