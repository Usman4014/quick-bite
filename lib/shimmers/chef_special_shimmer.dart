import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChefSpecialShimmer extends StatelessWidget {
  const ChefSpecialShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(
            3,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 280,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        //================================================
                        // IMAGE
                        //================================================

                        Container(
                          height: 180,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                        ),

                        //================================================
                        // CONTENT
                        //================================================

                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 14,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(5),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Container(
                                height: 10,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(5),
                                ),
                              ),

                              const SizedBox(height: 12),

                              Container(
                                height: 12,
                                width: 65,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}