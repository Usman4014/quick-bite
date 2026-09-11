// ignore_for_file: file_names

import 'package:get/get.dart';

import 'package:quick_bite/models/CartItem_Model.dart';

import 'package:quick_bite/controllers/Offer_Controller.dart';
import 'package:quick_bite/controllers/PromoCode_Controller.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';

class CartController extends GetxController {
  //==========================================================
  // CART ITEMS
  //==========================================================

  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  //==========================================================
  // LOADING
  //==========================================================

  final RxBool isLoading = true.obs;

  //==========================================================
  // CONTROLLERS
  //==========================================================

  OfferController get offerController => Get.find<OfferController>();

  PromoCodeController get promoCodeController =>
      Get.find<PromoCodeController>();

  AppSettingsController get settingsController =>
      Get.find<AppSettingsController>();

  //==========================================================
  // INIT
  //==========================================================

  @override
  void onInit() {
    super.onInit();

    // Cart is currently local data.
    // Keep the loading state ready for future persistent cart loading.
    Future.microtask(() {
      isLoading.value = false;
    });
  }

  //==========================================================
  // ADD TO CART
  //==========================================================

  void addToCart(CartItemModel item) {
    int index = -1;

    //========================================================
    // PRODUCT
    //========================================================

    if (item.product != null) {
      index = cartItems.indexWhere(
        (cartItem) =>
            cartItem.product?.id == item.product!.id &&
            cartItem.selectedVariant?.name == item.selectedVariant?.name,
      );
    }
    //========================================================
    // SPECIAL DEAL
    //========================================================
    else if (item.specialDeal != null) {
      index = cartItems.indexWhere(
        (cartItem) => cartItem.specialDeal?.id == item.specialDeal!.id,
      );
    }

    //========================================================
    // UPDATE EXISTING ITEM
    //========================================================

    if (index != -1) {
      cartItems[index].quantity.value += item.quantity.value;
    }
    //========================================================
    // ADD NEW ITEM
    //========================================================
    else {
      cartItems.add(item);
    }

    //========================================================
    // REFRESH AUTOMATIC OFFER
    //========================================================

    offerController.refreshAppliedOffer();
  }

  //==========================================================
  // REMOVE ITEM
  //==========================================================

  void removeFromCart(CartItemModel item) {
    cartItems.remove(item);

    offerController.refreshAppliedOffer();
  }

  //==========================================================
  // CLEAR CART
  //==========================================================

  void clearCart() {
    cartItems.clear();

    offerController.refreshAppliedOffer();
  }

  //==========================================================
  // TOTAL PRODUCTS
  //==========================================================

  int get totalProducts {
    return cartItems.length;
  }

  //==========================================================
  // TOTAL QUANTITY
  //==========================================================

  int get totalQuantity {
    int total = 0;

    for (final CartItemModel item in cartItems) {
      total += item.quantity.value;
    }

    return total;
  }

  //==========================================================
  // SUBTOTAL
  //==========================================================

  double get subTotal {
    double total = 0;

    for (final CartItemModel item in cartItems) {
      total += item.totalPrice;
    }

    return total;
  }

  //==========================================================
  // AUTOMATIC OFFER DISCOUNT
  //==========================================================

  double get offerDiscount {
    return offerController.appliedOfferDiscount.value;
  }

  //==========================================================
  // SUBTOTAL AFTER OFFER
  //==========================================================

  double get discountedSubTotal {
    final value = subTotal - offerDiscount;

    return value < 0 ? 0 : value;
  }

  //==========================================================
  // PROMO DISCOUNT
  //==========================================================

  double get promoDiscount {
    return promoCodeController.discountValue;
  }

  //==========================================================
  // FINAL DISCOUNTED SUBTOTAL
  //==========================================================

  double get finalSubTotal {
    final value = discountedSubTotal - promoDiscount;

    return value < 0 ? 0 : value;
  }

  //==========================================================
  // DELIVERY FEE
  //==========================================================

  double get deliveryFee {
    return settingsController.deliveryFee;
  }

  //==========================================================
  // TAX
  //==========================================================

  double get tax {
    return finalSubTotal * 0.10;
  }

  //==========================================================
  // FINAL TOTAL
  //==========================================================

  double get totalAmount {
    return finalSubTotal + deliveryFee + tax;
  }

  //==========================================================
  // INCREASE QUANTITY
  //==========================================================

  void increaseQuantity(CartItemModel item) {
    item.quantity.value++;

    offerController.refreshAppliedOffer();
  }

  //==========================================================
  // DECREASE QUANTITY
  //==========================================================

  void decreaseQuantity(CartItemModel item) {
    if (item.quantity.value > 1) {
      item.quantity.value--;

      offerController.refreshAppliedOffer();
    }
  }
}
