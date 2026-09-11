// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/views/auth/banner_screen.dart';
import 'package:quick_bite/views/auth/email_login_screen.dart';
import 'package:quick_bite/views/auth/forgot_password_screen.dart';
import 'package:quick_bite/views/auth/method_selection_screen.dart';
import 'package:quick_bite/views/auth/otp_verification_screen.dart';
import 'package:quick_bite/views/auth/phone_login_screen.dart';
import 'package:quick_bite/views/auth/signup_screen.dart';
import 'package:quick_bite/views/auth/splash_screen.dart';
import 'package:quick_bite/views/checkout/checkout_screen.dart';
import 'package:quick_bite/views/checkout/order_success_screen.dart';
import 'package:quick_bite/views/landing/home/chefs_special/chef_special_screen.dart';
import 'package:quick_bite/views/landing/home/notifications/notification_screen.dart';
import 'package:quick_bite/views/landing/home/popular_right_now/popular_right_now_screen.dart';
import 'package:quick_bite/views/landing/home/special_deals/special_deals_details_screen.dart';
import 'package:quick_bite/views/landing/home/special_deals/special_deals_screen.dart';
import 'package:quick_bite/views/landing/landing_screen.dart';
import 'package:quick_bite/views/landing/offers/offer_details_screen.dart';
import 'package:quick_bite/views/landing/order/order_details/order_details_screen.dart';
import 'package:quick_bite/views/landing/order/track_order/track_order_screen.dart';
import 'package:quick_bite/views/product/listofproducts_screen.dart';
import 'package:quick_bite/views/product/product_details_screen.dart';
import 'package:quick_bite/views/profile/aboutquickbite/about_quick_bite_screen.dart';
import 'package:quick_bite/views/profile/change_password_screen.dart';
import 'package:quick_bite/views/profile/contactus/contact_us_screen.dart';
import 'package:quick_bite/views/profile/edit_profile_screen.dart';
import 'package:quick_bite/views/profile/myaddresses/SelectLocationScreen.dart';
import 'package:quick_bite/views/profile/myaddresses/add_address_screen.dart';
import 'package:quick_bite/views/profile/myaddresses/address_screen.dart';
import 'package:quick_bite/views/profile/myfavorites/favorites_screen.dart';
import 'package:quick_bite/views/profile/paymentmethods/add_credit_debit_card_screen.dart';
import 'package:quick_bite/views/profile/paymentmethods/paymentmethodscreen.dart';
import 'package:quick_bite/views/profile/privacypolicy/privacy_policy_screen.dart';
import 'package:quick_bite/views/profile/ratings&feedbacks/ratings_feedbacks._screen.dart';
import 'package:quick_bite/views/profile/ratings&feedbacks/write_app_review_screen.dart';

class AppPages {
  static final pages = <GetPage>[
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.banner, page: () => BannerScreen()),
    GetPage(
      name: AppRoutes.methodSelection,
      page: () => MethodSelectionScreen(),
    ),
    GetPage(name: AppRoutes.phoneLogin, page: () => PhoneLoginScreen()),
    GetPage(name: AppRoutes.emailLogin, page: () => EmailLoginScreen()),
    GetPage(name: AppRoutes.forgotpassword, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.changepassword, page: () => ChangePasswordScreen()),
    GetPage(name: AppRoutes.otpVerfication, page: () => OtpVerificationScreen()),
    GetPage(name: AppRoutes.signup, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.landing, page: () => LandingScreen()),
    GetPage(name: AppRoutes.listofproducts, page: () => ListOfProducts()),
    GetPage(
      name: AppRoutes.productdetailsscreen,
      page: () => ProductDetailsScreen(),
    ),
    GetPage(name: AppRoutes.editprofile, page: () => EditProfileScreen()),
    GetPage(name: AppRoutes.address, page: () => AddressScreen()),
    GetPage(name: AppRoutes.addaddress, page: () => AddAddressScreen()),
    GetPage(name: AppRoutes.paymentMethod, page: () => PaymentMethod_Screen()),
    GetPage(
      name: AppRoutes.addcreditdebitcard,
      page: () => AddCreditDebitCardScreen(),
    ),
    GetPage(name: AppRoutes.favorites, page: () => FavoritesScreen()),
    GetPage(
      name: AppRoutes.ratingsfeedbacks,
      page: () => Ratings_Feedbacks_Screen(),
    ),
    GetPage(name: AppRoutes.writeAppReview, page: () => WriteAppReviewScreen()),
    GetPage(name: AppRoutes.aboutquickbite, page: () => AboutQuickBiteScreen()),
    GetPage(name: AppRoutes.privacypolicy, page: () => PrivacyPolicyScreen()),
    GetPage(name: AppRoutes.contactus, page: () => ContactUsScreen()),
    GetPage(
      name: AppRoutes.specialDealDetails,
      page: () => SpecialDealsDetailsScreen(),
    ),
    GetPage(name: AppRoutes.specialDeal, page: () => SpecialDealsScreen()),
    GetPage(name: AppRoutes.notifications, page: () => NotificationScreen()),
    GetPage(name: AppRoutes.checkout, page: () => CheckoutScreen()),
    GetPage(name: AppRoutes.orderSuccess, page: () => OrderSuccessScreen()),
    GetPage(name: AppRoutes.trackOrder, page: () => TrackOrderScreen()),
    GetPage(name: AppRoutes.orderDetails, page: () => OrderDetailsScreen()),
    GetPage(
      name: AppRoutes.offerDetails,
      page: () => OfferDetailsScreen(offer: Get.arguments as OfferModel),
    ),
    GetPage(
      name: AppRoutes.popularRightNow,
      page: () => PopularRightNowScreen(),
    ),
    GetPage(name: AppRoutes.chefsSpecial, page: () => ChefSpecialScreen()),
    GetPage(
      name: AppRoutes.selectLocationStreet,
      page: () => SelectLocationScreen(),
    ),
  ];
}
