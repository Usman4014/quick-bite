// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          children: [
            //====================================================
            // PRODUCT IMAGE SHIMMER
            //====================================================

            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: height * .48,
                width: width,
                color: Colors.white,
              ),
            ),

            //====================================================
            // TOP APP BAR SHIMMER
            //====================================================

            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: _box(
                      width: 42,
                      height: 42,
                      radius: 21,
                    ),
                  ),

                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: _box(
                      width: 42,
                      height: 42,
                      radius: 21,
                    ),
                  ),
                ],
              ),
            ),

            //====================================================
            // DETAILS PANEL
            //====================================================

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: height * .60,
                  width: width,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade600,
                        blurRadius: 100,
                      ),
                    ],
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),

                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,

                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const SizedBox(height: 25),

                            //====================================
                            // TITLE + RATING
                            //====================================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,

                              children: [
                                Expanded(
                                  child: _box(
                                    width: double.infinity,
                                    height: 24,
                                    radius: 6,
                                  ),
                                ),

                                const SizedBox(width: 20),

                                _box(
                                  width: 65,
                                  height: 18,
                                  radius: 6,
                                ),
                              ],
                            ),

                            const SizedBox(height: 15),

                            //====================================
                            // DESCRIPTION
                            //====================================

                            _box(
                              width: double.infinity,
                              height: 12,
                              radius: 5,
                            ),

                            const SizedBox(height: 8),

                            _box(
                              width: width * .75,
                              height: 12,
                              radius: 5,
                            ),

                            const SizedBox(height: 25),

                            //====================================
                            // PRICE
                            //====================================

                            _box(
                              width: 85,
                              height: 22,
                              radius: 6,
                            ),

                            const SizedBox(height: 25),

                            //====================================
                            // SIZE TITLE
                            //====================================

                            _box(
                              width: 90,
                              height: 18,
                              radius: 6,
                            ),

                            const SizedBox(height: 15),

                            //====================================
                            // SIZE OPTIONS
                            //====================================

                            Row(
                              children: [
                                _box(
                                  width: 90,
                                  height: 45,
                                  radius: 10,
                                ),

                                const SizedBox(width: 12),

                                _box(
                                  width: 90,
                                  height: 45,
                                  radius: 10,
                                ),

                                const SizedBox(width: 12),

                                _box(
                                  width: 90,
                                  height: 45,
                                  radius: 10,
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            //====================================
                            // QUANTITY
                            //====================================

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,

                              children: [
                                _box(
                                  width: 80,
                                  height: 18,
                                  radius: 6,
                                ),

                                _box(
                                  width: 130,
                                  height: 45,
                                  radius: 10,
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            //====================================
                            // REVIEWS
                            //====================================

                            _box(
                              width: 90,
                              height: 18,
                              radius: 6,
                            ),

                            const SizedBox(height: 15),

                            _box(
                              width: double.infinity,
                              height: 70,
                              radius: 12,
                            ),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //====================================================
            // ADD TO CART SHIMMER
            //====================================================

            Positioned(
              left: 20,
              right: 20,
              bottom: 20,

              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,

                child: _box(
                  width: double.infinity,
                  height: 55,
                  radius: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}