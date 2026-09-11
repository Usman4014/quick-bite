// ignore_for_file: avoid_print, file_names

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';
import 'package:quick_bite/controllers/Cart_Controller.dart';
import 'package:quick_bite/controllers/PaymentMethod_Controller.dart';
import 'package:quick_bite/controllers/PromoCode_Controller.dart';
import 'package:quick_bite/controllers/User_Controller.dart';

import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/enums/Payment_Method.dart';
import 'package:quick_bite/enums/Payment_Status.dart';

import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/models/AddressTypeVariant_Model.dart';
import 'package:quick_bite/models/CartItem_Model.dart';
import 'package:quick_bite/models/OrderItem_Model.dart';
import 'package:quick_bite/models/Order_Model.dart';
import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';
import 'package:quick_bite/models/Rider_Model.dart';
import 'package:quick_bite/models/Special_Deals_Model.dart';

import 'package:quick_bite/services/Order_Service.dart';
import 'package:quick_bite/widgets/snack_bar.dart';

class OrderController extends GetxController {
  //============================================================
  // CONTROLLERS
  //============================================================

  final CartController cartController = Get.find<CartController>();

  final AddressController addressController = Get.find<AddressController>();

  final PaymentMethodController paymentMethodController =
      Get.find<PaymentMethodController>();

  final PromoCodeController promoCodeController =
      Get.find<PromoCodeController>();

  final UserController userController = Get.find<UserController>();

  final AppSettingsController settingsController =
      Get.find<AppSettingsController>();

  //============================================================
  // LOADING
  //============================================================

  final RxBool isLoading = true.obs;

  //============================================================
  // SERVICE
  //============================================================

  final OrderService orderService = OrderService();

  //============================================================
  // ORDERS
  //============================================================

  final RxList<OrderModel> orders = <OrderModel>[].obs;

  final Rxn<OrderModel> lastOrder = Rxn<OrderModel>();

  //============================================================
  // ORDER INDEX
  //============================================================

  final Map<String, OrderModel> _orderIndex = <String, OrderModel>{};

  //============================================================
  // FIRESTORE SUBSCRIPTION
  //============================================================

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;

  //============================================================
  // USER LISTENER
  //============================================================

  Worker? _userWorker;

  //============================================================
  // CURRENT LISTENING USER
  //============================================================

  String? _listeningUserId;

  //============================================================
  // INITIALIZATION
  //============================================================

  @override
  void onInit() {
    super.onInit();

    _syncOrderIndex();

    //==========================================================
    // START LISTENER
    //==========================================================

    startOrdersListener();

    //==========================================================
    // LISTEN FOR LOGIN / LOGOUT / USER CHANGES
    //==========================================================

    _userWorker = ever(userController.currentUser, (_) {
      startOrdersListener();
    });
  }

  //============================================================
  // SYNC ORDER INDEX
  //============================================================

  void _syncOrderIndex() {
    _orderIndex
      ..clear()
      ..addEntries(orders.map((order) => MapEntry(order.orderId, order)));
  }

  //============================================================
  // ADD ORDER TO LOCAL STATE
  //============================================================

  void _addOrderLocally(OrderModel order) {
    _orderIndex[order.orderId] = order;

    final existingIndex = orders.indexWhere(
      (item) => item.orderId == order.orderId,
    );

    if (existingIndex == -1) {
      orders.add(order);
    } else {
      orders[existingIndex] = order;
    }
  }

  //============================================================
  // REMOVE ORDER FROM LOCAL STATE
  //============================================================

  void _removeOrderLocally(String orderId) {
    _orderIndex.remove(orderId);

    orders.removeWhere((order) => order.orderId == orderId);
  }

  //============================================================
  // STOP ORDERS LISTENER
  //============================================================

  Future<void> stopOrdersListener() async {
    await _ordersSubscription?.cancel();

    _ordersSubscription = null;
    _listeningUserId = null;

    isLoading.value = false;
  }

  //============================================================
  // START ORDERS LISTENER
  //============================================================

  void startOrdersListener() {
    final user = userController.currentUser.value;

    //==========================================================
    // NO USER
    //==========================================================

    if (user == null) {
      isLoading.value = false;

      orders.clear();
      _orderIndex.clear();
      lastOrder.value = null;

      return;
    }

    //==========================================================
    // SAME USER + EXISTING LISTENER
    //==========================================================

    if (_ordersSubscription != null && _listeningUserId == user.id) {
      return;
    }

    //==========================================================
    // DIFFERENT USER
    //==========================================================

    if (_ordersSubscription != null && _listeningUserId != user.id) {
      _ordersSubscription?.cancel();

      _ordersSubscription = null;
      _listeningUserId = null;

      orders.clear();
      _orderIndex.clear();
      lastOrder.value = null;
    }

    //==========================================================
    // LOADING
    //==========================================================

    isLoading.value = true;

    //==========================================================
    // SYNC LOCAL INDEX
    //==========================================================

    _syncOrderIndex();

    _listeningUserId = user.id;

    //==========================================================
    // FIRESTORE LISTENER
    //==========================================================

    _ordersSubscription = orderService
        .getUserOrders(user.id)
        .listen(
          _handleOrdersSnapshot,

          //====================================================
          // ERROR
          //====================================================
          onError: (error) {
            isLoading.value = false;

            // Firestore may reconnect automatically.
            print('❌ Order Firestore listener error: $error');
          },

          //====================================================
          // DONE
          //====================================================
          onDone: () {
            _ordersSubscription = null;
            _listeningUserId = null;

            isLoading.value = false;
          },

          cancelOnError: false,
        );
  }

  //============================================================
  // HANDLE FIRESTORE SNAPSHOT
  //============================================================

  void _handleOrdersSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    //==========================================================
    // FIRESTORE RESPONDED
    //==========================================================

    isLoading.value = false;

    //==========================================================
    // BUILD COMPLETE ORDER LIST
    //
    // IMPORTANT:
    // Firestore snapshot is the source of truth.
    // We rebuild the local list from Firestore instead of
    // requiring orders to already exist in _orderIndex.
    //==========================================================

    final List<OrderModel> firestoreOrders = [];

    final Map<String, OrderModel> firestoreIndex = <String, OrderModel>{};

    //==========================================================
    // PROCESS ORDERS
    //==========================================================

    for (final document in snapshot.docs) {
      try {
        final data = document.data();

        final OrderModel? order = _orderFromFirestore(document.id, data);

        if (order == null) {
          continue;
        }

        firestoreOrders.add(order);

        firestoreIndex[order.orderId] = order;
      } catch (e) {
        // Ignore malformed individual orders.
        // Other valid orders should still load.
        print('⚠️ Failed to parse order ${document.id}: $e');
      }
    }

    //==========================================================
    // UPDATE LOCAL STATE
    //==========================================================

    orders.assignAll(firestoreOrders);

    _orderIndex
      ..clear()
      ..addAll(firestoreIndex);

    //==========================================================
    // UPDATE LAST ORDER
    //==========================================================

    final currentLastOrderId = lastOrder.value?.orderId;

    if (currentLastOrderId != null) {
      final updatedLastOrder = firestoreIndex[currentLastOrderId];

      if (updatedLastOrder != null) {
        lastOrder.value = updatedLastOrder;
      }
    }

    //==========================================================
    // IF THERE IS NO LAST ORDER BUT ORDERS EXIST
    //==========================================================

    if (lastOrder.value == null && firestoreOrders.isNotEmpty) {
      lastOrder.value = firestoreOrders.first;
    }

    //==========================================================
    // DEBUG
    //==========================================================

    print('✅ Customer orders loaded: ${firestoreOrders.length}');
  }

  //============================================================
  // FIRESTORE → ORDER MODEL
  //============================================================

  OrderModel? _orderFromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    //==========================================================
    // ORDER ID
    //==========================================================

    final String orderId = data['orderId']?.toString().trim().isNotEmpty == true
        ? data['orderId'].toString()
        : documentId;

    //==========================================================
    // USER ID
    //==========================================================

    final String userId = data['userId']?.toString() ?? '';

    if (userId.isEmpty) {
      return null;
    }

    //==========================================================
    // STATUS
    //==========================================================

    final OrderStatus status = _orderStatusFromString(
      data['status']?.toString(),
    );

    //==========================================================
    // PAYMENT METHOD
    //==========================================================

    final PaymentMethod paymentMethod = _paymentMethodFromString(
      data['paymentMethod']?.toString(),
    );

    //==========================================================
    // PAYMENT STATUS
    //==========================================================

    final PaymentStatus paymentStatus = _paymentStatusFromString(
      data['paymentStatus']?.toString(),
    );

    //==========================================================
    // ITEMS
    //==========================================================

    final List<OrderItemModel> items = _orderItemsFromFirestore(data['items']);

    //==========================================================
    // ADDRESS
    //==========================================================

    final AddressModel? deliveryAddress = _addressFromFirestore(
      data['deliveryAddress'],
    );

    if (deliveryAddress == null) {
      return null;
    }

    //==========================================================
    // ORDER DATE
    //==========================================================

    final DateTime orderDate =
        _dateTimeFromFirestore(data['orderDate']) ?? DateTime.now();

    //==========================================================
    // ESTIMATED DELIVERY TIME
    //==========================================================

    final DateTime? estimatedDeliveryTime = _dateTimeFromFirestore(
      data['estimatedDeliveryTime'],
    );

    //==========================================================
    // DELIVERED AT
    //==========================================================

    final DateTime? deliveredAt = _dateTimeFromFirestore(data['deliveredAt']);

    //==========================================================
    // RIDER
    //==========================================================

    RiderModel? rider;

    final riderData = data['rider'];

    if (riderData is Map) {
      rider = _riderFromFirestore(Map<String, dynamic>.from(riderData));
    }

    //==========================================================
    // CREATE ORDER MODEL
    //==========================================================

    return OrderModel(
      userId: userId,

      orderId: orderId,

      items: items,

      deliveryAddress: deliveryAddress,

      status: status,

      paymentMethod: paymentMethod,

      paymentStatus: paymentStatus,

      subtotal: _doubleValue(data['subtotal']),

      deliveryFee: _doubleValue(data['deliveryFee']),

      offerDiscount: _doubleValue(data['offerDiscount']),

      promoDiscount: _doubleValue(data['promoDiscount']),

      tax: _doubleValue(data['tax']),

      totalAmount: _doubleValue(data['totalAmount']),

      orderDate: orderDate,

      estimatedDeliveryTime: estimatedDeliveryTime,

      deliveredAt: deliveredAt,

      promoCode: data['promoCode']?.toString(),

      notes: data['notes']?.toString(),

      rider: rider,
    );
  }

  //============================================================
  // FIRESTORE → ADDRESS MODEL
  //============================================================

  AddressModel? _addressFromFirestore(dynamic value) {
    if (value is! Map) {
      return null;
    }

    final Map<String, dynamic> data = Map<String, dynamic>.from(value);

    //==========================================================
    // ADDRESS TYPE
    //==========================================================

    final addressTypeData = data['addressType'];

    final AddressTypeVariantModel addressType = AddressTypeVariantModel.fromMap(
      addressTypeData is Map
          ? Map<String, dynamic>.from(addressTypeData)
          : <String, dynamic>{},
    );

    //==========================================================
    // ADDRESS
    //==========================================================

    return AddressModel(
      id: data['id']?.toString() ?? '',

      phoneNumber: data['phoneNumber']?.toString() ?? '',

      addressType: addressType,

      streetAddress: data['streetAddress']?.toString() ?? '',

      apartment: data['apartment']?.toString(),

      neighborhood: data['neighborhood']?.toString() ?? '',

      deliveryInstructions: data['deliveryInstructions']?.toString(),

      isDefault: data['isDefault'] == true,

      isSelected: data['isSelected'] == true,

      latitude: _doubleValue(data['latitude']),

      longitude: _doubleValue(data['longitude']),
    );
  }

  //============================================================
  // FIRESTORE → ORDER ITEMS
  //============================================================

  List<OrderItemModel> _orderItemsFromFirestore(dynamic value) {
    if (value is! List) {
      return <OrderItemModel>[];
    }

    final List<OrderItemModel> items = <OrderItemModel>[];

    for (final itemData in value) {
      if (itemData is! Map) {
        continue;
      }

      try {
        final Map<String, dynamic> data = Map<String, dynamic>.from(itemData);

        //======================================================
        // PRODUCT
        //======================================================

        ProductModel? product;

        final productData = data['product'];

        if (productData is Map) {
          product = _productFromFirestore(
            Map<String, dynamic>.from(productData),
          );
        }

        //======================================================
        // VARIANT
        //======================================================

        ProductVariantModel? variant;

        final variantData = data['variant'];

        if (variantData is Map) {
          variant = _productVariantFromFirestore(
            Map<String, dynamic>.from(variantData),
          );
        }

        //======================================================
        // SPECIAL DEAL
        //======================================================

        SpecialDealsModel? specialDeal;

        final specialDealData = data['specialDeal'];

        if (specialDealData is Map) {
          specialDeal = _specialDealFromFirestore(
            Map<String, dynamic>.from(specialDealData),
          );
        }

        //======================================================
        // QUANTITY
        //======================================================

        int quantity = 1;

        final quantityData = data['quantity'];

        if (quantityData is num) {
          quantity = quantityData.toInt();
        } else if (quantityData is String) {
          quantity = int.tryParse(quantityData) ?? 1;
        }

        if (quantity < 1) {
          quantity = 1;
        }

        //======================================================
        // UNIT PRICE
        //======================================================

        final double unitPrice = _doubleValue(data['unitPrice']);

        //======================================================
        // NOTES
        //======================================================

        final String? notes = data['notes']?.toString();

        //======================================================
        // CREATE ORDER ITEM
        //======================================================

        items.add(
          OrderItemModel(
            product: product,

            variant: variant,

            specialDeal: specialDeal,

            quantity: quantity,

            unitPrice: unitPrice,

            notes: notes,
          ),
        );
      } catch (e) {
        print('⚠️ Failed to parse order item: $e');
      }
    }

    return items;
  }

  //============================================================
  // FIRESTORE → PRODUCT MODEL
  //============================================================

  ProductModel _productFromFirestore(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id']?.toString() ?? '',

      name: data['name']?.toString() ?? '',

      description: data['description']?.toString() ?? '',

      image: data['image']?.toString() ?? '',

      categoryId: data['categoryId']?.toString() ?? '',

      category: data['category']?.toString() ?? '',

      isChefSpecial: data['isChefSpecial'] == true,

      variants: _variantsFromFirestore(data['variants']),

      totalOrders: _intValue(data['totalOrders']),
    );
  }

  //============================================================
  // FIRESTORE → PRODUCT VARIANT
  //============================================================

  ProductVariantModel _productVariantFromFirestore(Map<String, dynamic> data) {
    return ProductVariantModel(
      id: data['id']?.toString() ?? '',

      name: data['name']?.toString() ?? '',

      price: _doubleValue(data['price']),
    );
  }

  //============================================================
  // FIRESTORE → PRODUCT VARIANTS
  //============================================================

  List<ProductVariantModel> _variantsFromFirestore(dynamic value) {
    if (value is! List) {
      return <ProductVariantModel>[];
    }

    return value
        .whereType<Map>()
        .map(
          (variant) =>
              _productVariantFromFirestore(Map<String, dynamic>.from(variant)),
        )
        .toList();
  }

  //============================================================
  // FIRESTORE → SPECIAL DEAL
  //============================================================

  SpecialDealsModel _specialDealFromFirestore(Map<String, dynamic> data) {
    return SpecialDealsModel(
      id: data['id']?.toString() ?? '',

      title: data['title']?.toString() ?? '',

      description: data['description']?.toString() ?? '',

      bannerImage: data['bannerImage']?.toString() ?? '',

      squareImage: data['squareImage']?.toString() ?? '',

      items: _stringList(data['items']),

      totalOrders: _intValue(data['totalOrders']),

      originalPrice: _doubleValue(data['originalPrice']),

      dealPrice: _doubleValue(data['dealPrice']),

      discount: data['discount']?.toString() ?? '',

      specialNote: data['specialNote']?.toString() ?? '',

      isChefSpecial: data['isChefSpecial'] == true,

      isFeatured: data['isFeatured'] == true,

      isActive: data['isActive'] != false,
    );
  }

  //============================================================
  // FIRESTORE → RIDER
  //============================================================

  RiderModel _riderFromFirestore(Map<String, dynamic> data) {
    return RiderModel(
      id: data['id']?.toString() ?? '',

      name: data['name']?.toString() ?? '',

      phone: data['phone']?.toString() ?? '',

      profileImage: data['profileImage']?.toString() ?? '',

      vehicleType: data['vehicleType']?.toString() ?? '',

      vehicleNumber: data['vehicleNumber']?.toString() ?? '',

      rating: _doubleValue(data['rating']),

      isAvailable: data['isAvailable'] == true,
    );
  }

  //============================================================
  // ORDER STATUS CONVERTER
  //============================================================

  OrderStatus _orderStatusFromString(String? value) {
    if (value == null) {
      return OrderStatus.pending;
    }

    for (final status in OrderStatus.values) {
      if (status.name == value) {
        return status;
      }
    }

    return OrderStatus.pending;
  }

  //============================================================
  // PAYMENT METHOD CONVERTER
  //============================================================

  PaymentMethod _paymentMethodFromString(String? value) {
    if (value == null) {
      return PaymentMethod.cashOnDelivery;
    }

    for (final method in PaymentMethod.values) {
      if (method.name == value) {
        return method;
      }
    }

    return PaymentMethod.cashOnDelivery;
  }

  //============================================================
  // PAYMENT STATUS CONVERTER
  //============================================================

  PaymentStatus _paymentStatusFromString(String? value) {
    if (value == null) {
      return PaymentStatus.pending;
    }

    for (final status in PaymentStatus.values) {
      if (status.name == value) {
        return status;
      }
    }

    return PaymentStatus.pending;
  }

  //============================================================
  // DATETIME CONVERTER
  //============================================================

  DateTime? _dateTimeFromFirestore(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  //============================================================
  // DOUBLE CONVERTER
  //============================================================

  double _doubleValue(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }

  //============================================================
  // INT CONVERTER
  //============================================================

  int _intValue(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  //============================================================
  // STRING LIST CONVERTER
  //============================================================

  List<String> _stringList(dynamic value) {
    if (value is! List) {
      return <String>[];
    }

    return value.map((item) => item.toString()).toList();
  }

  //============================================================
  // GENERATE ORDER ID
  //============================================================

  String generateOrderId() {
    final random = Random();

    final number = 10000 + random.nextInt(90000);

    return '#QB$number';
  }

  //============================================================
  // PLACE ORDER
  //============================================================

  Future<bool> placeOrder() async {
    //==========================================================
    // CHECK CART
    //==========================================================

    if (cartController.cartItems.isEmpty) {
      Snack_Bar.show(
        title: "Cart Empty",
        message: "Please add items before placing an order.",
        icon: FontAwesomeIcons.cartShopping,
      );

      return false;
    }

    //==========================================================
    // CHECK ORDER AVAILABILITY
    //==========================================================

    if (!settingsController.canPlaceOrders) {
      Snack_Bar.show(
        title: "Orders Unavailable",
        message: "Orders are currently unavailable. Please try again later.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // CHECK ADDRESS
    //==========================================================

    final address = addressController.selectedAddress;

    if (address == null) {
      Snack_Bar.show(
        title: "No Address Selected",
        message: "Please select a delivery address.",
        icon: FontAwesomeIcons.locationDot,
      );

      return false;
    }

    //==========================================================
    // CHECK PAYMENT METHOD AVAILABILITY
    //==========================================================

    if (!paymentMethodController.hasAvailablePaymentMethod) {
      Snack_Bar.show(
        title: "Payment Unavailable",
        message:
            "No payment method is currently available. Please try again later.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // PAYMENT METHOD
    //==========================================================

    final selectedCard = paymentMethodController.selectedPaymentMethod;

    final PaymentMethod paymentMethod;

    if (selectedCard == null) {
      //========================================================
      // CASH ON DELIVERY
      //========================================================

      if (!paymentMethodController.isCashOnDeliveryEnabled) {
        Snack_Bar.show(
          title: "Select Payment Method",
          message: "Please select an available payment method.",
          icon: FontAwesomeIcons.circleExclamation,
        );

        return false;
      }

      paymentMethod = PaymentMethod.cashOnDelivery;
    } else {
      //========================================================
      // ONLINE PAYMENT
      //========================================================

      if (!paymentMethodController.isOnlinePaymentEnabled) {
        Snack_Bar.show(
          title: "Payment Unavailable",
          message: "Online payment is currently unavailable.",
          icon: FontAwesomeIcons.circleExclamation,
        );

        return false;
      }

      paymentMethod = selectedCard.paymentMethod;
    }

    //==========================================================
    // CREATE ORDER ITEMS
    //==========================================================

    final items = cartController.cartItems.map((item) {
      //======================================================
      // SPECIAL DEAL
      //======================================================

      if (item.specialDeal != null) {
        return OrderItemModel(
          specialDeal: item.specialDeal,

          quantity: item.quantity.value,

          unitPrice: item.specialDeal!.dealPrice,
        );
      }

      //======================================================
      // PRODUCT
      //======================================================

      return OrderItemModel(
        product: item.product,

        variant: item.selectedVariant,

        quantity: item.quantity.value,

        unitPrice: item.selectedVariant!.price,
      );
    }).toList();

    //==========================================================
    // PRICES
    //==========================================================

    final double subtotal = cartController.subTotal;

    final double offerDiscount = cartController.offerDiscount;

    final double discountedSubTotal = cartController.discountedSubTotal;

    final double promoDiscount = promoCodeController.discountValue;

    //==========================================================
    // FINAL SUBTOTAL
    //==========================================================

    final double finalSubtotal = discountedSubTotal - promoDiscount < 0
        ? 0
        : discountedSubTotal - promoDiscount;

    //==========================================================
    // MINIMUM ORDER
    //==========================================================

    final double minimumOrderAmount = settingsController.minimumOrderAmount;

    if (minimumOrderAmount > 0 && finalSubtotal < minimumOrderAmount) {
      Snack_Bar.show(
        title: "Minimum Order",
        message:
            "Your order must be at least "
            "\$${minimumOrderAmount.toStringAsFixed(2)} "
            "after discounts.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // TAX
    //==========================================================

    final double tax = finalSubtotal * 0.10;

    //==========================================================
    // DELIVERY FEE
    //==========================================================

    final double deliveryFee = cartController.deliveryFee;

    //==========================================================
    // FINAL TOTAL
    //==========================================================

    final double totalAmount = finalSubtotal + deliveryFee + tax;

    //==========================================================
    // CURRENT USER
    //==========================================================

    final user = userController.currentUser.value;

    if (user == null) {
      Snack_Bar.show(
        title: "Login Required",
        message: "Please log in before placing an order.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // DATES
    //==========================================================

    final DateTime orderDate = DateTime.now();

    final DateTime estimatedDeliveryTime = orderDate.add(
      Duration(minutes: settingsController.estimatedDeliveryMinutes),
    );

    //==========================================================
    // CREATE ORDER
    //==========================================================

    final order = OrderModel(
      orderId: generateOrderId(),

      userId: user.id,

      items: items,

      deliveryAddress: address,

      status: OrderStatus.pending,

      paymentMethod: paymentMethod,

      paymentStatus: paymentMethod == PaymentMethod.cashOnDelivery
          ? PaymentStatus.pending
          : PaymentStatus.paid,

      subtotal: subtotal,

      offerDiscount: offerDiscount,

      promoDiscount: promoDiscount,

      deliveryFee: deliveryFee,

      tax: tax,

      totalAmount: totalAmount,

      orderDate: orderDate,

      estimatedDeliveryTime: estimatedDeliveryTime,

      promoCode: promoCodeController.appliedPromoCode.value?.code,

      rider: null,
    );

    //==========================================================
    // SAVE LOCALLY FIRST
    //==========================================================

    _addOrderLocally(order);

    lastOrder.value = order;

    //==========================================================
    // SAVE TO FIRESTORE
    //==========================================================

    try {
      await orderService.createOrder(order);

      //========================================================
      // ADMIN NOTIFICATION
      //========================================================

      if (settingsController.newOrderNotifications) {
        try {
          await orderService.createAdminOrderNotification(order);
        } catch (_) {
          // Notification failure must not
          // fail an otherwise successful order.
        }
      }

      //========================================================
      // ENSURE LISTENER IS RUNNING
      //========================================================

      startOrdersListener();
    } catch (_) {
      //========================================================
      // ORDER SAVE FAILED
      //========================================================

      _removeOrderLocally(order.orderId);

      if (lastOrder.value?.orderId == order.orderId) {
        lastOrder.value = null;
      }

      Snack_Bar.show(
        title: "Order Failed",
        message: "Unable to save your order. Please try again.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // CLEAR CART
    //==========================================================

    cartController.clearCart();

    //==========================================================
    // CLEAR PROMO
    //==========================================================

    promoCodeController.removeAppliedPromo();

    //==========================================================
    // SUCCESS
    //==========================================================

    Snack_Bar.show(
      title: "Order Placed",
      message: "Your order has been placed successfully.",
      icon: FontAwesomeIcons.circleCheck,
    );

    return true;
  }

  //============================================================
  // REORDER
  //============================================================

  void reorder(OrderModel order) {
    cartController.clearCart();

    for (final item in order.items) {
      cartController.cartItems.add(
        CartItemModel(
          product: item.product,

          specialDeal: item.specialDeal,

          selectedVariant: item.variant,

          quantity: item.quantity,
        ),
      );
    }

    cartController.cartItems.refresh();
  }

  //============================================================
  // CANCEL ORDER
  //============================================================

  Future<bool> cancelOrder(String orderId) async {
    //==========================================================
    // CHECK ADMIN CANCELLATION SETTING
    //==========================================================

    if (!settingsController.allowCancellation) {
      Snack_Bar.show(
        title: "Cancellation Unavailable",
        message: "Order cancellation is currently unavailable.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // FIND ORDER
    //==========================================================

    final order = getOrderById(orderId);

    if (order == null) {
      Snack_Bar.show(
        title: "Order Not Found",
        message: "Unable to find this order.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // ONLY PENDING ORDERS
    //==========================================================

    if (order.status != OrderStatus.pending) {
      Snack_Bar.show(
        title: "Cannot Cancel Order",
        message: "This order can no longer be cancelled.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }

    //==========================================================
    // UPDATE FIRESTORE
    //==========================================================

    try {
      await orderService.cancelOrder(orderId);

      //========================================================
      // UPDATE LOCAL ORDER
      //========================================================

      order.status = OrderStatus.cancelled;

      _orderIndex[orderId] = order;

      orders.refresh();

      if (lastOrder.value?.orderId == orderId) {
        lastOrder.value = order;
      }

      //========================================================
      // SUCCESS
      //========================================================

      Snack_Bar.show(
        title: "Order Cancelled",
        message: "Your order has been cancelled successfully.",
        icon: FontAwesomeIcons.circleCheck,
      );

      return true;
    } catch (_) {
      Snack_Bar.show(
        title: "Cancellation Failed",
        message: "Unable to cancel your order. Please try again.",
        icon: FontAwesomeIcons.circleExclamation,
      );

      return false;
    }
  }

  //============================================================
  // FIND ORDER BY ID
  //============================================================

  OrderModel? getOrderById(String orderId) {
    if (orderId.trim().isEmpty) {
      return null;
    }

    //==========================================================
    // FAST PATH
    //==========================================================

    final indexedOrder = _orderIndex[orderId];

    if (indexedOrder != null) {
      return indexedOrder;
    }

    //==========================================================
    // FALLBACK
    //==========================================================

    for (final order in orders) {
      if (order.orderId == orderId) {
        _orderIndex[orderId] = order;

        return order;
      }
    }

    return null;
  }

  //============================================================
  // ALL ORDERS
  //============================================================

  List<OrderModel> get allOrders => orders;

  //============================================================
  // CURRENT ORDER
  //============================================================

  OrderModel? getCurrentOrder(String orderId) {
    return getOrderById(orderId);
  }

  //============================================================
  // PENDING ORDERS
  //============================================================

  List<OrderModel> get pendingOrders {
    return orders
        .where((order) => order.status == OrderStatus.pending)
        .toList(growable: false);
  }

  //============================================================
  // PREPARING ORDERS
  //============================================================

  List<OrderModel> get preparingOrders {
    return orders
        .where((order) => order.status == OrderStatus.preparing)
        .toList(growable: false);
  }

  //============================================================
  // ON THE WAY ORDERS
  //============================================================

  List<OrderModel> get onTheWayOrders {
    return orders
        .where((order) => order.status == OrderStatus.onTheWay)
        .toList(growable: false);
  }

  //============================================================
  // ONGOING ORDERS
  //============================================================

  List<OrderModel> get ongoingOrders {
    return orders
        .where(
          (order) =>
              order.status == OrderStatus.pending ||
              order.status == OrderStatus.preparing ||
              order.status == OrderStatus.onTheWay,
        )
        .toList(growable: false);
  }

  //============================================================
  // COMPLETED ORDERS
  //============================================================

  List<OrderModel> get completedOrders {
    return orders
        .where((order) => order.status == OrderStatus.delivered)
        .toList(growable: false);
  }

  //============================================================
  // TOTAL SAVED AMOUNT
  //============================================================

  double get totalSavedAmount {
    return completedOrders.fold(0.0, (total, order) {
      //======================================================
      // SPECIAL DEAL SAVINGS
      //======================================================

      final specialDealSavings = order.items.fold(0.0, (itemTotal, item) {
        if (item.specialDeal == null) {
          return itemTotal;
        }

        return itemTotal + (item.specialDeal!.savedAmount * item.quantity);
      });

      //======================================================
      // OFFER SAVINGS
      //======================================================

      final offerSavings = order.offerDiscount;

      //======================================================
      // PROMO SAVINGS
      //======================================================

      final promoSavings = order.promoDiscount;

      return total + specialDealSavings + offerSavings + promoSavings;
    });
  }

  //============================================================
  // CANCELLED ORDERS
  //============================================================

  List<OrderModel> get canceledOrders {
    return orders
        .where((order) => order.status == OrderStatus.cancelled)
        .toList(growable: false);
  }

  //============================================================
  // CLEAR ORDERS
  //============================================================

  void clearOrders() {
    orders.clear();

    _orderIndex.clear();

    lastOrder.value = null;
  }

  //============================================================
  // CLEANUP
  //============================================================

  @override
  void onClose() {
    _userWorker?.dispose();

    _ordersSubscription?.cancel();

    _ordersSubscription = null;

    _listeningUserId = null;

    _orderIndex.clear();

    super.onClose();
  }
}
