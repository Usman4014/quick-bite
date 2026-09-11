// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TrackOrderShimmer extends StatelessWidget {
  const TrackOrderShimmer({super.key});

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

  Widget _orderInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 60, height: 12),

              const SizedBox(height: 7),

              _box(width: 110, height: 20),

              const SizedBox(height: 12),

              Row(
                children: [
                  _box(width: 18, height: 18, radius: 5),

                  const SizedBox(width: 8),

                  _box(width: 90, height: 12),
                ],
              ),

              const SizedBox(height: 12),

              _box(width: 85, height: 28, radius: 20),
            ],
          ),

          _box(width: 150, height: 150, radius: 15),
        ],
      ),
    );
  }

  Widget _timelineShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 3 ? 0 : 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _box(width: 34, height: 34, radius: 17),

                    if (index != 3)
                      Container(
                        width: 2,
                        height: 35,
                        color: Colors.grey.shade300,
                      ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 120, height: 14),

                      const SizedBox(height: 7),

                      _box(width: 190, height: 11),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _riderShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          _box(width: 50, height: 50, radius: 25),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 120, height: 14),

                const SizedBox(height: 8),

                _box(width: 200, height: 11),

                const SizedBox(height: 5),

                _box(width: 160, height: 11),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_box(width: 125, height: 13), _box(width: 90, height: 16)],
      ),
    );
  }

  Widget _addressShimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 85, height: 32, radius: 15),

          const SizedBox(height: 15),

          _box(width: 130, height: 15),

          const SizedBox(height: 10),

          Row(
            children: [
              _box(width: 14, height: 14, radius: 4),

              const SizedBox(width: 8),

              Expanded(child: _box(width: double.infinity, height: 13)),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            children: [
              _box(width: 14, height: 14, radius: 4),

              const SizedBox(width: 8),

              _box(width: 130, height: 13),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order information
          _orderInfoCard(),

          const SizedBox(height: 30),

          // Timeline
          _timelineShimmer(),

          const SizedBox(height: 20),

          // Rider title
          _box(width: 90, height: 16),

          const SizedBox(height: 10),

          // Rider
          _riderShimmer(),

          const SizedBox(height: 25),

          // Estimated delivery
          _deliveryShimmer(),

          const SizedBox(height: 25),

          // Delivery address title
          _box(width: 125, height: 16),

          const SizedBox(height: 10),

          // Address
          _addressShimmer(),

          const SizedBox(height: 35),
        ],
      ),
    );
  }
}
