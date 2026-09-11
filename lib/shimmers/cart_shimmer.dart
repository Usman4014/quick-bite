// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartShimmer extends StatelessWidget {
  const CartShimmer({super.key});

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

  Widget _cartItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            //==================================================
            // IMAGE
            //==================================================

            _box(width: 85, height: 85, radius: 10),

            const SizedBox(width: 12),

            //==================================================
            // CONTENT
            //==================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 150, height: 16, radius: 5),

                  const SizedBox(height: 10),

                  _box(width: 100, height: 12, radius: 5),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _box(width: 65, height: 15, radius: 5),

                      _box(width: 95, height: 35, radius: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _offerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget _summary() {
    return Shimmer.fromColors(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 75, height: 13, radius: 5),
                _box(width: 65, height: 13, radius: 5),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 90, height: 13, radius: 5),
                _box(width: 55, height: 13, radius: 5),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 70, height: 13, radius: 5),
                _box(width: 55, height: 13, radius: 5),
              ],
            ),

            const SizedBox(height: 15),

            Divider(color: Colors.grey.shade300),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _box(width: 70, height: 17, radius: 5),
                _box(width: 80, height: 18, radius: 5),
              ],
            ),
          ],
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
        //======================================================
        // ITEMS TITLE
        //======================================================

        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: _box(width: 70, height: 16, radius: 5),
        ),

        const SizedBox(height: 15),

        //======================================================
        // CART ITEMS
        //======================================================
        _cartItem(),

        const SizedBox(height: 15),

        _cartItem(),

        const SizedBox(height: 15),

        _cartItem(),

        const SizedBox(height: 15),

        //======================================================
        // OFFER
        //======================================================
        _offerCard(),

        const SizedBox(height: 15),

        //======================================================
        // SUMMARY
        //======================================================
        _summary(),

        const SizedBox(height: 20),

        //======================================================
        // CHECKOUT BUTTON
        //======================================================
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: _box(width: double.infinity, height: 55, radius: 15),
        ),
      ],
    );
  }
}
