// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class DealAppBar extends StatelessWidget {
  final SpecialDealsModel deal;

  const DealAppBar({
    super.key,
    required this.deal,
  });

  @override
  Widget build(BuildContext context) {
    final SpecialDealsController specialDealsController =
        Get.find<SpecialDealsController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Back_Button(),

            Obx(
              () => GestureDetector(
                onTap: () {
                  specialDealsController.toggleFavorite(deal);

                  Snack_Bar.show(
                    title: deal.isFavorite.value
                        ? "Added to Favorites"
                        : "Removed from Favorites",
                    message: deal.isFavorite.value
                        ? "${deal.title} has been added to favorites"
                        : "${deal.title} has been removed from favorites",
                    icon: deal.isFavorite.value
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: FaIcon(
                      deal.isFavorite.value
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: deal.isFavorite.value
                          ? AppColors.primary
                          : Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}