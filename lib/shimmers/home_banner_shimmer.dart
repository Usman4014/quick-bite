import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeBannerShimmer extends StatelessWidget {
  const HomeBannerShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}