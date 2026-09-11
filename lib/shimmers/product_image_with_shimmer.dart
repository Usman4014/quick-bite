import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductImageWithShimmer extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;

  const ProductImageWithShimmer({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,

      child: Image.network(
        imageUrl,

        height: height,
        width: width,

        fit: fit,

        //==============================================================
        // IMAGE IS STILL LOADING
        //==============================================================

        loadingBuilder: (
          BuildContext context,
          Widget child,
          ImageChunkEvent? loadingProgress,
        ) {
          if (loadingProgress == null) {
            //==========================================================
            // IMAGE COMPLETELY LOADED
            //==========================================================

            return child;
          }

          //============================================================
          // IMAGE STILL LOADING → SHOW SHIMMER
          //============================================================

          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,

            child: Container(
              height: height,
              width: width,
              color: Colors.white,
            ),
          );
        },

        //==============================================================
        // IMAGE FAILED
        //==============================================================

        errorBuilder: (
          BuildContext context,
          Object error,
          StackTrace? stackTrace,
        ) {
          return Container(
            height: height,
            width: width,

            color: Colors.grey.shade200,

            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 45,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}