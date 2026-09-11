// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AddressShimmer extends StatelessWidget {
  const AddressShimmer({super.key});

  Widget _line({
    required double width,
    required double height,
    double radius = 6,
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

  Widget _addressCard() {
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
              _line(
                width: 42,
                height: 42,
                radius: 21,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _line(
                  width: double.infinity,
                  height: 17,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _line(
            width: double.infinity,
            height: 13,
          ),

          const SizedBox(height: 9),

          _line(
            width: 240,
            height: 13,
          ),

          const SizedBox(height: 9),

          _line(
            width: 180,
            height: 13,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _line(
                width: 80,
                height: 30,
                radius: 15,
              ),
              const Spacer(),
              _line(
                width: 35,
                height: 35,
                radius: 18,
              ),
              const SizedBox(width: 10),
              _line(
                width: 35,
                height: 35,
                radius: 18,
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
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 15,
        ),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, _) => const SizedBox(height: 15),
          itemBuilder: (_, index) {
            return _addressCard();
          },
        ),
      ),
    );
  }
}