// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesShimmer extends StatelessWidget {
  const FavoritesShimmer({super.key});

  Widget _box({
    required double width,
    required double height,
    double radius = 10,
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

  Widget _favoriteCard() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          // Product image
          _box(
            width: 90,
            height: 90,
            radius: 15,
          ),

          const SizedBox(width: 14),

          // Product information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(
                  width: 145,
                  height: 15,
                  radius: 6,
                ),

                const SizedBox(height: 9),

                _box(
                  width: 100,
                  height: 12,
                  radius: 5,
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    _box(
                      width: 55,
                      height: 13,
                      radius: 5,
                    ),

                    const SizedBox(width: 10),

                    _box(
                      width: 45,
                      height: 13,
                      radius: 5,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _box(
                  width: 75,
                  height: 16,
                  radius: 6,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Favorite icon
          _box(
            width: 32,
            height: 32,
            radius: 16,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _favoriteCard();
      },
    );
  }
}