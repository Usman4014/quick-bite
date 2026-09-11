import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/theme/App_Constants.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/views/landing/cart/cart_screen.dart';
import 'package:quick_bite/views/landing/home/homescreen.dart';
import 'package:quick_bite/views/landing/offers/offers_screen.dart';
import 'package:quick_bite/views/landing/order/orders_screen.dart';
import 'package:quick_bite/views/profile/profilescreen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final LandingController landingController = Get.find<LandingController>();
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: landingController.tabController,
      tabs: [
        PersistentTabConfig(
          screen: const HomeScreen(),
          item: ItemConfig(
            icon: const FaIcon(
              FontAwesomeIcons.house,
              size: AppConstants.bottombariconSize,
            ),
            title: "Home",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: OrdersScreen(),
          item: ItemConfig(
            icon: const FaIcon(
              FontAwesomeIcons.receipt,
              size: AppConstants.bottombariconSize,
            ),
            title: "Orders",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: CartScreen(),
          item: ItemConfig(
            icon: const FaIcon(
              FontAwesomeIcons.cartShopping,
              size: AppConstants.bottombariconSize,
            ),
            title: "Cart",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: OffersScreen(),
          item: ItemConfig(
            icon: const FaIcon(
              FontAwesomeIcons.gift,
              size: AppConstants.bottombariconSize,
            ),
            title: "Offers",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),

        PersistentTabConfig(
          screen: ProfileScreen(),
          item: ItemConfig(
            icon: const FaIcon(
              FontAwesomeIcons.user,
              size: AppConstants.bottombariconSize,
            ),
            title: "Profile",
            activeForegroundColor: AppColors.primary,
            inactiveForegroundColor: Colors.grey,
          ),
        ),
      ],

      navBarBuilder: (navBarConfig) => Style4BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 2)],
        ),
        itemAnimationProperties: ItemAnimation(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
      ),
    );
  }
}
