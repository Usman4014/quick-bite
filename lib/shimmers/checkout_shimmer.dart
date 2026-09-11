// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutShimmer extends StatelessWidget {
  const CheckoutShimmer({super.key});

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

  Widget _section({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
      children: [
        //========================================================
        // DELIVERY ADDRESS
        //========================================================

        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _box(width: 45, height: 45, radius: 12),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(width: 110, height: 14, radius: 5),
                      const SizedBox(height: 8),
                      _box(width: 180, height: 11, radius: 5),
                    ],
                  ),
                ),

                _box(width: 25, height: 25, radius: 5),
              ],
            ),
          ),
        ),

        const SizedBox(height: 30),

        //========================================================
        // PAYMENT METHOD
        //========================================================
        _section(height: 100),

        const SizedBox(height: 30),

        //========================================================
        // ORDER ITEMS
        //========================================================
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 110, height: 18, radius: 5),

              const SizedBox(height: 15),

              _orderItem(),
              const SizedBox(height: 10),
              _orderItem(),
              const SizedBox(height: 10),
              _orderItem(),
            ],
          ),
        ),

        const SizedBox(height: 30),

        //========================================================
        // PROMO CODE
        //========================================================
        _section(height: 65),

        const SizedBox(height: 30),

        //========================================================
        // ORDER NOTE
        //========================================================
        _section(height: 100),

        const SizedBox(height: 30),

        //========================================================
        // ORDER SUMMARY
        //========================================================
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _summaryRow(),
                const SizedBox(height: 15),
                _summaryRow(),
                const SizedBox(height: 15),
                _summaryRow(),
                const SizedBox(height: 15),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 10),
                _summaryRow(large: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _orderItem() {
    return Row(
      children: [
        _box(width: 65, height: 65, radius: 10),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(width: 140, height: 14, radius: 5),
              const SizedBox(height: 8),
              _box(width: 80, height: 11, radius: 5),
            ],
          ),
        ),

        _box(width: 65, height: 14, radius: 5),
      ],
    );
  }

  Widget _summaryRow({bool large = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _box(width: large ? 70 : 90, height: large ? 18 : 13, radius: 5),
        _box(width: large ? 85 : 65, height: large ? 18 : 13, radius: 5),
      ],
    );
  }
}
