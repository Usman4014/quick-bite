import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListOfProductsShimmer extends StatelessWidget {
  const ListOfProductsShimmer({super.key});

  Widget _shimmerBox({
    required double width,
    required double height,
    double radius = 5,
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

  Widget _productCard() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              //==================================================
              // PRODUCT IMAGE
              //==================================================

              Padding(
                padding: const EdgeInsets.only(left: 9),
                child: _shimmerBox(
                  width: 115,
                  height: 115,
                  radius: 8,
                ),
              ),

              //==================================================
              // PRODUCT CONTENT
              //==================================================

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      //==========================================
                      // TITLE + FAVORITE
                      //==========================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _shimmerBox(
                              width: 130,
                              height: 14,
                            ),
                          ),

                          const SizedBox(width: 15),

                          _shimmerBox(
                            width: 20,
                            height: 20,
                            radius: 10,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      //==========================================
                      // DESCRIPTION
                      //==========================================

                      _shimmerBox(
                        width: 160,
                        height: 9,
                      ),

                      const SizedBox(height: 6),

                      _shimmerBox(
                        width: 120,
                        height: 9,
                      ),

                      const SizedBox(height: 15),

                      //==========================================
                      // PRICE + RATING + ADD
                      //==========================================

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _shimmerBox(
                            width: 55,
                            height: 13,
                          ),

                          _shimmerBox(
                            width: 35,
                            height: 12,
                          ),

                          _shimmerBox(
                            width: 65,
                            height: 32,
                            radius: 8,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 6,
      itemBuilder: (context, index) {
        return _productCard();
      },
    );
  }
}