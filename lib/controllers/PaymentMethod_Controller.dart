// ignore_for_file: file_names

import 'package:get/get.dart';

import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';

import 'package:quick_bite/models/PaymentMethod_Model.dart';

class PaymentMethodController extends GetxController {
  //============================================================
  // CONTROLLERS
  //============================================================

  final UserController userController = Get.find<UserController>();

  final AppSettingsController settingsController =
      Get.find<AppSettingsController>();

  //============================================================
  // CURRENT USER PAYMENT METHODS
  //============================================================

  List<PaymentMethodModel> get paymentMethods {
    return userController.currentUser.value?.paymentMethods ?? [];
  }

  //============================================================
  // CASH ON DELIVERY AVAILABLE
  //============================================================

  bool get isCashOnDeliveryEnabled {
    return settingsController.cashOnDelivery;
  }

  //============================================================
  // ONLINE PAYMENT AVAILABLE
  //============================================================

  bool get isOnlinePaymentEnabled {
    return settingsController.onlinePayment;
  }

  //============================================================
  // ANY PAYMENT METHOD AVAILABLE
  //============================================================

  bool get hasAvailablePaymentMethod {
    return isCashOnDeliveryEnabled ||
        (isOnlinePaymentEnabled && paymentMethods.isNotEmpty);
  }

  //============================================================
  // ADD CARD
  //============================================================

  void addCard(PaymentMethodModel card) {
    if (!isOnlinePaymentEnabled) {
      return;
    }

    // First card becomes selected automatically.
    if (paymentMethods.isEmpty) {
      card.isSelected = true;
    }

    // If this card is being added as default,
    // remove default from every other card.
    if (card.isDefault) {
      for (var item in paymentMethods) {
        item.isDefault = false;
      }
    }

    paymentMethods.add(card);

    userController.currentUser.refresh();
  }

  //============================================================
  // REMOVE CARD
  //============================================================

  void removeCard(PaymentMethodModel paymentMethod) {
    userController.currentUser.value?.paymentMethods.remove(paymentMethod);

    userController.currentUser.refresh();
  }

  //============================================================
  // SELECT CASH ON DELIVERY
  //============================================================

  void selectCashOnDelivery() {
    if (!isCashOnDeliveryEnabled) {
      return;
    }

    for (var paymentMethod in paymentMethods) {
      paymentMethod.isSelected = false;
    }

    userController.currentUser.refresh();
  }

  //============================================================
  // UPDATE CARD
  //============================================================

  void updateCard(PaymentMethodModel updatedCard) {
    if (updatedCard.isDefault) {
      for (var item in paymentMethods) {
        item.isDefault = false;
      }
    }

    final index = paymentMethods.indexWhere(
      (card) => card.id == updatedCard.id,
    );

    if (index != -1) {
      paymentMethods[index] = updatedCard;

      userController.currentUser.refresh();
    }
  }

  //============================================================
  // SELECT PAYMENT METHOD
  //============================================================

  void selectPaymentMethod(PaymentMethodModel selectedPaymentMethod) {
    if (!isOnlinePaymentEnabled) {
      return;
    }

    for (var paymentMethod in paymentMethods) {
      paymentMethod.isSelected = false;
    }

    selectedPaymentMethod.isSelected = true;

    userController.currentUser.refresh();
  }

  //============================================================
  // SELECTED PAYMENT METHOD
  //============================================================

  PaymentMethodModel? get selectedPaymentMethod {
    try {
      return paymentMethods.firstWhere(
        (paymentMethod) => paymentMethod.isSelected,
      );
    } catch (_) {
      return null;
    }
  }

  //============================================================
  // CASH ON DELIVERY SELECTED
  //============================================================

  bool get isCashOnDelivery {
    return paymentMethods.every((card) => !card.isSelected);
  }

  //============================================================
  // SET DEFAULT PAYMENT METHOD
  //============================================================

  void setDefaultPaymentMethod(PaymentMethodModel paymentMethod) {
    for (var item in paymentMethods) {
      item.isDefault = false;
    }

    paymentMethod.isDefault = true;

    userController.currentUser.refresh();
  }

  //============================================================
  // DEFAULT PAYMENT METHOD
  //============================================================

  PaymentMethodModel? get defaultPaymentMethod {
    final methods = userController.currentUser.value?.paymentMethods ?? [];

    return methods.firstWhereOrNull((method) => method.isDefault);
  }

  //============================================================
  // FIND PAYMENT METHOD
  //============================================================

  PaymentMethodModel? getPaymentMethodById(String id) {
    try {
      return userController.currentUser.value!.paymentMethods.firstWhere(
        (paymentMethod) => paymentMethod.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  //============================================================
  // TOTAL PAYMENT METHODS
  //============================================================

  int get totalPaymentMethods {
    return userController.currentUser.value?.paymentMethods.length ?? 0;
  }

  //============================================================
  // CLEAR PAYMENT METHODS
  //============================================================

  void clearPaymentMethods() {
    userController.currentUser.value?.paymentMethods.clear();

    userController.currentUser.refresh();
  }
}
