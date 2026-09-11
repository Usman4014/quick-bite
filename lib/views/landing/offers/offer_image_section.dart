// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:quick_bite/models/Offer_Model.dart';

class OfferImageSection extends StatelessWidget {
  final OfferModel offer;

  const OfferImageSection({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.4,
      width: width,
      color: Colors.grey.shade100,

      child: Image.network(
        offer.squareImage,

        fit: BoxFit.fill,

        //========================================================
        // LOADING
        //========================================================
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const Center(child: CircularProgressIndicator());
        },

        //========================================================
        // ERROR
        //========================================================
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              size: 50,
              color: Colors.grey.shade400,
            ),
          );
        },
      ),
    );
  }
}
