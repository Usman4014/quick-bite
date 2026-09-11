import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WhyQuickBiteShimmer extends StatelessWidget {
  const WhyQuickBiteShimmer({super.key});

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //======================================================
          // IMAGE
          //======================================================

          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 15),

          //======================================================
          // TITLE
          //======================================================

          Container(
            height: 14,
            width: 110,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(height: 10),

          //======================================================
          // SUBTITLE
          //======================================================

          Container(
            height: 9,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),

          const SizedBox(height: 6),

          Container(
            height: 9,
            width: 115,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        //========================================================
        // DESKTOP / LARGE SCREEN
        //========================================================

        if (width >= 700) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              4,
              (index) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: _shimmerCard(),
                  ),
                );
              },
            ),
          );
        }

        //========================================================
        // MOBILE
        //========================================================

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 30,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return _shimmerCard();
          },
        );
      },
    );
  }
}