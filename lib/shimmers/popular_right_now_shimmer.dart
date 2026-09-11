import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PopularRightNowShimmer extends StatelessWidget {
  const PopularRightNowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 12,
              top: 5,
              bottom: 5,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 280,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    //================================================
                    // IMAGE
                    //================================================

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        width: 115,
                        height: 115,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    //================================================
                    // CONTENT
                    //================================================

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                          top: 15,
                          bottom: 15,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 14,
                              width: 110,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 10,
                              width: 75,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Container(
                              height: 12,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Container(
                              height: 10,
                              width: 85,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
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
        },
      ),
    );
  }
}