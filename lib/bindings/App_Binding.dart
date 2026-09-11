// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:quick_bite/controllers/AppReview_Controller.dart';
import 'package:quick_bite/controllers/Category_Controller.dart';
import 'package:quick_bite/controllers/Chef_Special_Controller.dart';
import 'package:quick_bite/controllers/Landing_Controller.dart';
import 'package:quick_bite/controllers/Banner_Controller.dart';
import 'package:quick_bite/controllers/Offer_Controller.dart';
import 'package:quick_bite/controllers/PaymentMethod_Controller.dart';
import 'package:quick_bite/controllers/Popular_Item_Controller.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/services/Auth_Service.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/PromoCode_Controller.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/controllers/Order_Controller.dart';
import 'package:quick_bite/controllers/Notification_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';
import 'package:quick_bite/services/FCM_Service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    //===============================
    // AUTHENTICATION
    // ==============================

    Get.lazyPut<AuthService>(
      () => AuthService(),
      fenix: true,
    );

    Get.lazyPut<AuthController>(
      () => AuthController(),
      fenix: true,
    );

    // ==============================
    // LANDING
    // ==============================

    Get.lazyPut<LandingController>(
      () => LandingController(),
      fenix: true,
    );

    // ==============================
    // USER
    // ==============================

    Get.lazyPut<UserController>(
      () => UserController(),
      fenix: true,
    );

    // ==============================
    // FCM
    // ==============================

    Get.lazyPut<FCMService>(
      () => FCMService(),
      fenix: true,
    );

    // ==============================
    // SETTINGS
    // ==============================

    Get.lazyPut<AppSettingsController>(
      () => AppSettingsController(),
      fenix: true,
    );

    // ==============================
    // CATEGORY
    // ==============================

    Get.lazyPut<CategoryController>(
      () => CategoryController(),
      fenix: true,
    );

    // ==============================
    // PRODUCT
    // ==============================

    Get.lazyPut<ProductController>(
      () => ProductController(),
      fenix: true,
    );

    // ==============================
    // CART
    // ==============================

    Get.lazyPut<CartController>(
      () => CartController(),
      fenix: true,
    );

    // ==============================
    // ADDRESS
    // ==============================

    Get.lazyPut<AddressController>(
      () => AddressController(),
      fenix: true,
    );

    // ==============================
    // PAYMENT METHOD
    // ==============================

    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(),
      fenix: true,
    );

    // ==============================
    // ORDER
    // ==============================

    Get.lazyPut<OrderController>(
      () => OrderController(),
      fenix: true,
    );

    // ==============================
    // NOTIFICATION
    // ==============================

    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );

    // ==============================
    // PRODUCT REVIEW
    // ==============================

    Get.lazyPut<ReviewController>(
      () => ReviewController(),
      fenix: true,
    );

    // ==============================
    // APP REVIEW
    // ==============================

    Get.lazyPut<AppReviewController>(
      () => AppReviewController(),
      fenix: true,
    );

    // ==============================
    // SPECIAL DEALS
    // ==============================

    Get.lazyPut<SpecialDealsController>(
      () => SpecialDealsController(),
      fenix: true,
    );

    // ==============================
    // OFFER
    // ==============================

    Get.lazyPut<OfferController>(
      () => OfferController(),
      fenix: true,
    );

    // ==============================
    // PROMO CODE
    // ==============================

    Get.lazyPut<PromoCodeController>(
      () => PromoCodeController(),
      fenix: true,
    );

    // ==============================
    // POPULAR ITEM
    // ==============================

    Get.lazyPut<PopularItemController>(
      () => PopularItemController(),
      fenix: true,
    );

    // ==============================
    // CHEF SPECIAL
    // ==============================

    Get.lazyPut<ChefSpecialController>(
      () => ChefSpecialController(),
      fenix: true,
    );

    
    // ==============================
    // BANNERS
    // ==============================

    Get.put<BannerController>(
      BannerController(),
      permanent: true,
    );

     // ==============================
    // FIXED ASSETS
    // ==============================

    Get.put<FixedAssetController>(
      FixedAssetController(),
      permanent: true,
    );

   

  }
}