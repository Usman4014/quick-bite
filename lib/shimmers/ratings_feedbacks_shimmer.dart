// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RatingsFeedbacksShimmer extends StatelessWidget {
  const RatingsFeedbacksShimmer({super.key});

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

  Widget _reviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Profile image
              _box(
                width: 50,
                height: 50,
                radius: 25,
              ),

              const SizedBox(width: 12),

              // Name + date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(
                      width: 110,
                      height: 15,
                    ),
                    const SizedBox(height: 7),
                    _box(
                      width: 80,
                      height: 12,
                    ),
                  ],
                ),
              ),

              // Rating
              _box(
                width: 85,
                height: 18,
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Comment
          _box(
            width: double.infinity,
            height: 13,
          ),

          const SizedBox(height: 8),

          _box(
            width: 230,
            height: 13,
          ),

          const SizedBox(height: 18),

          // Buttons
          Row(
            children: [
              Expanded(
                child: _box(
                  width: double.infinity,
                  height: 42,
                  radius: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _box(
                  width: double.infinity,
                  height: 42,
                  radius: 21,
                ),
              ),
            ],
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
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        children: [
          //======================================================
          // REVIEW SUMMARY
          //======================================================

          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          const SizedBox(height: 25),

          //======================================================
          // YOUR REVIEW TITLE
          //======================================================

          _box(
            width: 105,
            height: 20,
          ),

          const SizedBox(height: 15),

          //======================================================
          // YOUR REVIEW
          //======================================================

          _reviewCard(),

          const SizedBox(height: 30),

          //======================================================
          // CUSTOMER REVIEWS TITLE
          //======================================================

          _box(
            width: 145,
            height: 20,
          ),

          const SizedBox(height: 15),

          //======================================================
          // CUSTOMER REVIEWS
          //======================================================

          _reviewCard(),

          const SizedBox(height: 15),

          _reviewCard(),

          const SizedBox(height: 15),

          _reviewCard(),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}