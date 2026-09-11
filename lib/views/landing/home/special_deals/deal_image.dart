// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

class DealImage extends StatelessWidget {
  final SpecialDealsModel deal;

  const DealImage({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: height * 0.36,
      width: width,
      color: Colors.grey.shade100,
      child: Hero(
        tag: deal.id,
        child: Image.network(
          deal.squareImage,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
                size: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}
