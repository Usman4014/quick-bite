// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/shimmers/why_quick_bite_shimmer.dart';
import 'why_quick_bite_card.dart';

class WhyQuickBite extends StatelessWidget {
  const WhyQuickBite({super.key});

  @override
  Widget build(BuildContext context) {
    final FixedAssetController controller = Get.find<FixedAssetController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        //======================================================
        // SECTION
        //======================================================

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //==================================================
            // TITLE
            //==================================================

            Text(
              'Why Quick Bite?',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Everything you need for a better food experience.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            //==================================================
            // LOADING
            //==================================================
            if (controller.isLoading.value)
              const WhyQuickBiteShimmer()
            //==================================================
            // CONTENT
            //==================================================
            else
              _buildCards(controller),
          ],
        );
      }),
    );
  }

  //============================================================
  // BUILD CARDS
  //============================================================

  Widget _buildCards(FixedAssetController controller) {
    final List<_WhyQuickBiteItem> items = [
      _WhyQuickBiteItem(
        assetId: 'why_quick_bite_customer_favorite',
        title: 'Customer Favorite',
        subtitle: 'Loved by customers for delicious food and great service.',
      ),

      _WhyQuickBiteItem(
        assetId: 'why_quick_bite_expert_chefs',
        title: 'Expert Chefs',
        subtitle:
            'Prepared by skilled chefs using carefully selected ingredients.',
      ),

      _WhyQuickBiteItem(
        assetId: 'why_quick_bite_fast_delivery',
        title: 'Fast Delivery',
        subtitle: 'Hot and fresh food delivered quickly to your doorstep.',
      ),

      _WhyQuickBiteItem(
        assetId: 'why_quick_bite_fresh_ingredients',
        title: 'Fresh Ingredients',
        subtitle: 'We use fresh, quality ingredients in every meal.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        //======================================================
        // DESKTOP / LARGE SCREEN
        //======================================================

        if (width >= 700) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: WhyQuickBiteCard(
                    title: item.title,
                    subtitle: item.subtitle,
                    imageUrl: controller.getImageUrl(item.assetId),
                  ),
                ),
              );
            }).toList(),
          );
        }

        //======================================================
        // MOBILE
        //======================================================

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 30,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final _WhyQuickBiteItem item = items[index];

            return WhyQuickBiteCard(
              title: item.title,
              subtitle: item.subtitle,
              imageUrl: controller.getImageUrl(item.assetId),
            );
          },
        );
      },
    );
  }
}

//================================================================
// ITEM
//================================================================

class _WhyQuickBiteItem {
  final String assetId;
  final String title;
  final String subtitle;

  const _WhyQuickBiteItem({
    required this.assetId,
    required this.title,
    required this.subtitle,
  });
}
