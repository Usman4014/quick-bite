// ignore_for_file: file_names

import 'dart:async';

import 'package:get/get.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/enums/Offer_Discount_Type.dart';
import 'package:quick_bite/enums/Offer_Target.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/models/Offer_Model.dart';
import 'package:quick_bite/services/Offer_Service.dart';

class OfferController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final OfferService _offerService = OfferService();

  //============================================================
  // ALL OFFERS
  //============================================================

  final RxList<OfferModel> offers = <OfferModel>[].obs;

  //============================================================
  // CART CONTROLLER
  //============================================================

  final CartController cartController = Get.find<CartController>();

  //============================================================
  // CURRENT AUTOMATIC OFFER
  //============================================================

  final Rxn<OfferModel> appliedOffer = Rxn<OfferModel>();

  final RxDouble appliedOfferDiscount = 0.0.obs;

  //============================================================
  // FIRESTORE SUBSCRIPTION
  //============================================================

  StreamSubscription<List<OfferModel>>? _offerSubscription;

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = false.obs;

  //============================================================
  // ERROR
  //============================================================

  final RxString errorMessage = ''.obs;

  //============================================================
  // INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    listenToOffers();

    ever(cartController.cartItems, (_) {
      refreshAppliedOffer();
    });
  }

  //============================================================
  // LISTEN TO FIRESTORE OFFERS
  //============================================================

  void listenToOffers() {
    _offerSubscription?.cancel();

    isLoading.value = true;
    errorMessage.value = '';

    _offerSubscription = _offerService.getOffersStream().listen(
      (List<OfferModel> data) {
        offers.assignAll(data);

        isLoading.value = false;
        errorMessage.value = '';

        refreshAppliedOffer();
      },
      onError: (error) {
        isLoading.value = false;

        errorMessage.value = error.toString();

        offers.clear();

        appliedOffer.value = null;
        appliedOfferDiscount.value = 0;
      },
    );
  }

  //============================================================
  // ACTIVE OFFERS
  //============================================================

  List<OfferModel> get activeOffers {
    final now = DateTime.now();

    return offers.where((offer) {
      return offer.isActive &&
          !now.isBefore(offer.startDate) &&
          now.isBefore(offer.endDate.add(const Duration(days: 1)));
    }).toList();
  }

  //============================================================
  // FEATURED OFFERS
  //============================================================

  List<OfferModel> get featuredOffers {
    return activeOffers.where((offer) => offer.isFeatured).toList();
  }

  //============================================================
  // ENDING SOON
  //============================================================

  List<OfferModel> get endingSoonOffers {
    final now = DateTime.now();

    return activeOffers.where((offer) {
      final remainingDays = offer.endDate.difference(now).inDays;

      return remainingDays >= 0 && remainingDays <= 3;
    }).toList();
  }

  //============================================================
  // FIND OFFER BY ID
  //============================================================

  OfferModel? getOfferById(String id) {
    try {
      return offers.firstWhere((offer) => offer.id == id);
    } catch (_) {
      return null;
    }
  }

  //============================================================
  // CHECK OFFER ACTIVE
  //============================================================

  bool isOfferActive(OfferModel offer) {
    final now = DateTime.now();

    return offer.isActive &&
        !now.isBefore(offer.startDate) &&
        now.isBefore(offer.endDate.add(const Duration(days: 1)));
  }

  //============================================================
  // GET ELIGIBLE CART AMOUNT
  //============================================================

  double getEligibleCartAmount(OfferModel offer) {
    double amount = 0;

    for (final CartItemModel item in cartController.cartItems) {
      if (_isCartItemEligible(item, offer)) {
        amount += item.totalPrice;
      }
    }

    return amount;
  }

  //============================================================
  // REFRESH AUTOMATIC OFFER
  //============================================================

  void refreshAppliedOffer() {
    //==========================================================
    // NO CART ITEMS
    //==========================================================

    if (cartController.cartItems.isEmpty) {
      appliedOffer.value = null;
      appliedOfferDiscount.value = 0;
      return;
    }

    //==========================================================
    // CURRENT ACTIVE OFFERS
    //==========================================================

    final now = DateTime.now();

    OfferModel? bestOffer;
    double bestDiscount = 0;

    //==========================================================
    // CHECK OFFERS
    //==========================================================

    for (final offer in offers) {
      //========================================================
      // ACTIVE
      //========================================================

      if (!offer.isActive) {
        continue;
      }

      if (now.isBefore(offer.startDate)) {
        continue;
      }

      if (!now.isBefore(offer.endDate.add(const Duration(days: 1)))) {
        continue;
      }

      //========================================================
      // CATEGORY OFFER ONLY
      //========================================================

      if (offer.target != OfferTarget.categories) {
        continue;
      }

      //========================================================
      // CATEGORY REQUIRED
      //========================================================

      final categoryId = offer.categoryId;

      if (categoryId == null || categoryId.isEmpty) {
        continue;
      }

      //========================================================
      // CALCULATE ELIGIBLE AMOUNT
      //========================================================

      double eligibleAmount = 0;

      for (final item in cartController.cartItems) {
        if (item.specialDeal != null) {
          continue;
        }

        final product = item.product;

        if (product == null) {
          continue;
        }

        if (product.categoryId == categoryId) {
          eligibleAmount += item.totalPrice;
        }
      }

      //========================================================
      // MINIMUM ORDER
      //========================================================

      if (eligibleAmount < offer.minimumOrderAmount) {
        continue;
      }

      //========================================================
      // CALCULATE DISCOUNT
      //========================================================

      double discount = 0;

      if (offer.discountType == OfferDiscountType.percentage) {
        discount = eligibleAmount * (offer.discountValue / 100);
      } else if (offer.discountType == OfferDiscountType.flat) {
        discount = offer.discountValue > eligibleAmount
            ? eligibleAmount
            : offer.discountValue;
      }

      //========================================================
      // BEST OFFER
      //========================================================

      if (discount > bestDiscount) {
        bestOffer = offer;
        bestDiscount = discount;
      }
    }

    //==========================================================
    // APPLY RESULT
    //==========================================================

    appliedOffer.value = bestOffer;
    appliedOfferDiscount.value = bestDiscount;
  }
  //============================================================
  // CALCULATE OFFER DISCOUNT
  //============================================================

  double calculateOfferDiscount(OfferModel offer) {
    return calculateDiscount(offer);
  }

  //============================================================
  // CHECK CART ITEM ELIGIBILITY
  //============================================================

  bool _isCartItemEligible(CartItemModel item, OfferModel offer) {
    //==========================================================
    // OFFER MUST BE CATEGORY BASED
    //==========================================================

    if (offer.target != OfferTarget.categories) {
      return false;
    }

    //==========================================================
    // OFFER MUST HAVE A CATEGORY
    //==========================================================

    final String? offerCategoryId = offer.categoryId;

    if (offerCategoryId == null || offerCategoryId.isEmpty) {
      return false;
    }

    //==========================================================
    // SPECIAL DEAL
    //==========================================================

    // Special deals are NOT eligible
    // because offers now belong only
    // to normal product categories.

    if (item.specialDeal != null) {
      return false;
    }

    //==========================================================
    // PRODUCT
    //==========================================================

    final product = item.product;

    if (product == null) {
      return false;
    }

    //==========================================================
    // CATEGORY MATCH
    //==========================================================

    return product.categoryId == offerCategoryId;
  }

  //============================================================
  // CHECK MINIMUM ORDER
  //============================================================

  bool meetsMinimumOrder(OfferModel offer) {
    final eligibleAmount = getEligibleCartAmount(offer);

    return eligibleAmount >= offer.minimumOrderAmount;
  }

  //============================================================
  // CHECK IF OFFER CAN APPLY
  //============================================================

  bool canApplyOffer(OfferModel offer) {
    //==========================================================
    // ACTIVE
    //==========================================================

    if (!isOfferActive(offer)) {
      return false;
    }

    //==========================================================
    // CATEGORY OFFER ONLY
    //==========================================================

    if (offer.target != OfferTarget.categories) {
      return false;
    }

    //==========================================================
    // CATEGORY MUST EXIST
    //==========================================================

    if (offer.categoryId == null || offer.categoryId!.isEmpty) {
      return false;
    }

    //==========================================================
    // CART
    //==========================================================

    if (cartController.cartItems.isEmpty) {
      return false;
    }

    //==========================================================
    // MINIMUM ORDER
    //==========================================================

    return meetsMinimumOrder(offer);
  }

  //============================================================
  // ELIGIBLE OFFERS
  //============================================================

  List<OfferModel> get eligibleOffers {
    return activeOffers.where((offer) => canApplyOffer(offer)).toList();
  }

  //============================================================
  // CALCULATE DISCOUNT
  //============================================================

  double calculateDiscount(OfferModel offer) {
    if (!canApplyOffer(offer)) {
      return 0;
    }

    final eligibleAmount = getEligibleCartAmount(offer);

    //==========================================================
    // PERCENTAGE
    //==========================================================

    if (offer.discountType == OfferDiscountType.percentage) {
      return eligibleAmount * (offer.discountValue / 100);
    }

    //==========================================================
    // FLAT
    //==========================================================

    if (offer.discountType == OfferDiscountType.flat) {
      return offer.discountValue > eligibleAmount
          ? eligibleAmount
          : offer.discountValue;
    }

    return 0;
  }

  //============================================================
  // BEST OFFER
  //============================================================

  OfferModel? get bestOffer {
    final eligible = eligibleOffers;

    if (eligible.isEmpty) {
      return null;
    }

    OfferModel best = eligible.first;

    double bestDiscount = calculateDiscount(best);

    for (final offer in eligible.skip(1)) {
      final discount = calculateDiscount(offer);

      if (discount > bestDiscount) {
        best = offer;
        bestDiscount = discount;
      }
    }

    return best;
  }

  //============================================================
  // BEST OFFER DISCOUNT
  //============================================================

  double get bestOfferDiscount {
    final offer = bestOffer;

    if (offer == null) {
      return 0;
    }

    return calculateDiscount(offer);
  }

  //============================================================
  // CLOSE
  //============================================================

  @override
  void onClose() {
    _offerSubscription?.cancel();

    super.onClose();
  }
}
