// ignore_for_file: file_names

import 'dart:async';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/services/PromoCode_Service.dart';
import 'package:quick_bite/models/PromoCode_Model.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class PromoCodeController extends GetxController {
  //==========================================================
  // CART CONTROLLER
  //==========================================================

  final CartController cartController = Get.find<CartController>();

  //==========================================================
  // PROMO CODE SERVICE
  //==========================================================

  final PromoCodeService _promoCodeService = PromoCodeService();

  //==========================================================
  // ALL PROMO CODES
  //==========================================================

  final RxList<PromoCodeModel> promoCodes = <PromoCodeModel>[].obs;

  //==========================================================
  // PROMO CODE LOOKUP CACHE
  //==========================================================

  final Map<String, PromoCodeModel> _promoCodeLookup =
      <String, PromoCodeModel>{};

  //==========================================================
  // CURRENTLY APPLIED PROMO CODE
  //==========================================================

  final Rxn<PromoCodeModel> appliedPromoCode = Rxn<PromoCodeModel>();

  //==========================================================
  // FIRESTORE SUBSCRIPTION
  //==========================================================

  StreamSubscription<List<PromoCodeModel>>? _promoCodeSubscription;

  //==========================================================
  // INIT
  //==========================================================

  @override
  void onInit() {
    super.onInit();

    listenToPromoCodes();
  }

  //==========================================================
  // LISTEN TO FIRESTORE PROMO CODES
  //==========================================================

  void listenToPromoCodes() {
    _promoCodeSubscription?.cancel();

    _promoCodeSubscription = _promoCodeService.getPromoCodesStream().listen(
      (List<PromoCodeModel> data) {
        //====================================================
        // UPDATE PROMO LIST
        //====================================================

        promoCodes.assignAll(data);

        //====================================================
        // REBUILD LOOKUP CACHE
        //====================================================

        _promoCodeLookup
          ..clear()
          ..addEntries(
            data.map(
              (promo) => MapEntry(promo.code.trim().toUpperCase(), promo),
            ),
          );

        //====================================================
        // VALIDATE CURRENTLY APPLIED PROMO
        //====================================================

        final applied = appliedPromoCode.value;

        if (applied != null) {
          final exists = _promoCodeLookup.containsKey(
            applied.code.trim().toUpperCase(),
          );

          if (!exists) {
            appliedPromoCode.value = null;
          }
        }
      },
      onError: (error) {
        promoCodes.clear();
        _promoCodeLookup.clear();
      },
    );
  }

  //==========================================================
  // APPLY PROMO CODE
  //==========================================================

  bool applyPromoCode(String code) {
    final promo = getPromoCode(code);

    //==========================================================
    // INVALID PROMO
    //==========================================================

    if (promo == null) {
      Snack_Bar.show(
        title: "Invalid Promo Code",
        message: "Please enter a valid promo code.",
        icon: FontAwesomeIcons.circleXmark,
      );

      return false;
    }

    //==========================================================
    // DATE / ACTIVE VALIDATION
    //==========================================================

    final DateTime now = DateTime.now();

    if (!promo.isActive ||
        now.isBefore(promo.startDate) ||
        now.isAfter(promo.endDate)) {
      Snack_Bar.show(
        title: "Promo Expired",
        message: "This promo code is no longer active.",
        icon: FontAwesomeIcons.clockRotateLeft,
      );

      return false;
    }

    //==========================================================
    // MINIMUM ORDER VALIDATION
    //==========================================================

    final double subtotal = cartController.subTotal;

    if (subtotal < promo.minimumOrderAmount) {
      final double remaining = promo.minimumOrderAmount - subtotal;

      Snack_Bar.show(
        title: "Minimum Order Not Reached",
        message:
            "Add \$${remaining.toStringAsFixed(2)} more to use this promo.",
        icon: FontAwesomeIcons.triangleExclamation,
      );

      return false;
    }

    //==========================================================
    // APPLY PROMO
    //==========================================================

    appliedPromoCode.value = promo;

    return true;
  }

  //==========================================================
  // PROMO DISCOUNT
  //==========================================================

  double get discountValue {
    final promo = appliedPromoCode.value;

    if (promo == null) {
      return 0;
    }

    //==========================================================
    // CHECK ORIGINAL SUBTOTAL
    //==========================================================

    final double subtotal = cartController.subTotal;

    if (subtotal < promo.minimumOrderAmount) {
      return 0;
    }

    //==========================================================
    // ELIGIBLE AMOUNT
    //==========================================================

    final double eligibleAmount = cartController.discountedSubTotal;

    //==========================================================
    // PERCENTAGE DISCOUNT
    //==========================================================

    if (promo.discountPercentage != null) {
      return eligibleAmount * (promo.discountPercentage! / 100);
    }

    //==========================================================
    // FIXED DISCOUNT
    //==========================================================

    if (promo.discountAmount != null) {
      return promo.discountAmount! > eligibleAmount
          ? eligibleAmount
          : promo.discountAmount!;
    }

    return 0;
  }

  //==========================================================
  // REMOVE APPLIED PROMO
  //==========================================================

  void removeAppliedPromo() {
    appliedPromoCode.value = null;
  }

  //==========================================================
  // ACTIVE PROMO CODES
  //==========================================================

  List<PromoCodeModel> get activePromoCodes {
    final DateTime now = DateTime.now();

    return promoCodes
        .where(
          (promo) =>
              promo.isActive &&
              !now.isBefore(promo.startDate) &&
              !now.isAfter(promo.endDate),
        )
        .toList(growable: false);
  }

  //==========================================================
  // GET PROMO CODE
  //==========================================================

  PromoCodeModel? getPromoCode(String code) {
    final String normalizedCode = code.trim().toUpperCase();

    if (normalizedCode.isEmpty) {
      return null;
    }

    return _promoCodeLookup[normalizedCode];
  }

  //==========================================================
  // GET PROMO CODE BY ID
  //==========================================================

  PromoCodeModel? getPromoCodeById(String id) {
    for (final promo in promoCodes) {
      if (promo.id == id) {
        return promo;
      }
    }

    return null;
  }

  //==========================================================
  // ADD PROMO CODE
  //==========================================================

  void addPromoCode(PromoCodeModel promoCode) {
    promoCodes.add(promoCode);

    _promoCodeLookup[promoCode.code.trim().toUpperCase()] = promoCode;
  }

  //==========================================================
  // UPDATE PROMO CODE
  //==========================================================

  void updatePromoCode(PromoCodeModel updatedPromoCode) {
    final int index = promoCodes.indexWhere(
      (promo) => promo.id == updatedPromoCode.id,
    );

    if (index == -1) {
      return;
    }

    final PromoCodeModel oldPromo = promoCodes[index];

    //========================================================
    // REMOVE OLD LOOKUP
    //========================================================

    _promoCodeLookup.remove(oldPromo.code.trim().toUpperCase());

    //========================================================
    // UPDATE LIST
    //========================================================

    promoCodes[index] = updatedPromoCode;

    //========================================================
    // ADD NEW LOOKUP
    //========================================================

    _promoCodeLookup[updatedPromoCode.code.trim().toUpperCase()] =
        updatedPromoCode;

    //========================================================
    // UPDATE APPLIED PROMO REFERENCE
    //========================================================

    if (appliedPromoCode.value?.id == updatedPromoCode.id) {
      appliedPromoCode.value = updatedPromoCode;
    }
  }

  //==========================================================
  // REMOVE PROMO CODE
  //==========================================================

  void removePromoCode(PromoCodeModel promoCode) {
    promoCodes.remove(promoCode);

    _promoCodeLookup.remove(promoCode.code.trim().toUpperCase());

    if (appliedPromoCode.value?.id == promoCode.id) {
      appliedPromoCode.value = null;
    }
  }

  //==========================================================
  // CLEAR PROMO CODES
  //==========================================================

  void clearPromoCodes() {
    promoCodes.clear();

    _promoCodeLookup.clear();

    appliedPromoCode.value = null;
  }

  //==========================================================
  // DISPOSE
  //==========================================================

  @override
  void onClose() {
    _promoCodeSubscription?.cancel();

    _promoCodeLookup.clear();

    super.onClose();
  }
}
