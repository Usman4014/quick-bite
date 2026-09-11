// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/enums/Payment_Status.dart';
import 'package:quick_bite/models/Order_Model.dart';

class OrderService {
  //============================================================
  // USERS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _usersCollection {
    return _firestore.collection('users');
  }
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //============================================================
  // ORDERS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  //============================================================
  // ADMIN NOTIFICATIONS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _adminNotificationsCollection =>
      _firestore.collection('admin_notifications');

  //============================================================
  // CREATE ORDER
  //============================================================

  Future<void> createOrder(OrderModel order) async {
    final orderRef = _ordersCollection.doc(order.orderId);
    final userRef = _usersCollection.doc(order.userId);

    await _firestore.runTransaction((transaction) async {
      //==========================================================
      // GET USER
      //==========================================================

      final userSnapshot = await transaction.get(userRef);

      if (!userSnapshot.exists) {
        throw Exception('Customer profile not found.');
      }

      final userData = userSnapshot.data() ?? {};

      final int currentTotalOrders =
          (userData['totalOrders'] as num?)?.toInt() ?? 0;

      //==========================================================
      // CREATE ORDER
      //==========================================================

      transaction.set(orderRef, {
        'orderId': order.orderId,
        'userId': order.userId,

        'status': order.status.name,

        'paymentMethod': order.paymentMethod.name,
        'paymentStatus': order.paymentStatus.name,

        'subtotal': order.subtotal,
        'deliveryFee': order.deliveryFee,
        'offerDiscount': order.offerDiscount,
        'promoDiscount': order.promoDiscount,
        'tax': order.tax,
        'totalAmount': order.totalAmount,

        'orderDate': Timestamp.fromDate(order.orderDate),

        'estimatedDeliveryTime': order.estimatedDeliveryTime != null
            ? Timestamp.fromDate(order.estimatedDeliveryTime!)
            : null,

        'deliveredAt': order.deliveredAt != null
            ? Timestamp.fromDate(order.deliveredAt!)
            : null,

        'promoCode': order.promoCode,
        'notes': order.notes,

        'deliveryAddress': _addressToMap(order),

        'items': order.items.map(_orderItemToMap).toList(),

        'rider': order.rider != null ? _riderToMap(order) : null,

        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      //==========================================================
      // INCREMENT CUSTOMER ORDER COUNT
      //==========================================================

      transaction.update(userRef, {
        'totalOrders': currentTotalOrders + 1,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  //============================================================
  // CREATE ADMIN NEW ORDER NOTIFICATION
  //============================================================

  Future<void> createAdminOrderNotification(OrderModel order) async {
    await _adminNotificationsCollection.add({
      //==========================================================
      // NOTIFICATION
      //==========================================================

      'title': 'New Order',

      'message': 'Order #${order.orderId} has been placed.',

      'type': 'order',

      'source': 'customer',

      'target': 'order',

      'targetId': order.orderId,

      //==========================================================
      // ORDER INFORMATION
      //==========================================================
      'orderId': order.orderId,

      'userId': order.userId,

      //==========================================================
      // READ STATUS
      //==========================================================
      'isRead': false,

      //==========================================================
      // TIMESTAMP
      //==========================================================
      'createdAt': FieldValue.serverTimestamp(),

      'sentAt': null,
    });
  }

  //============================================================
  // ADDRESS → FIRESTORE MAP
  //============================================================

  Map<String, dynamic> _addressToMap(OrderModel order) {
    final address = order.deliveryAddress;

    return {
      'id': address.id,

      'phoneNumber': address.phoneNumber,

      'addressType': {
        'id': address.addressType.id,

        'title': address.addressType.title,
      },

      'streetAddress': address.streetAddress,

      'apartment': address.apartment,

      'neighborhood': address.neighborhood,

      'deliveryInstructions': address.deliveryInstructions,

      'isDefault': address.isDefault,

      'isSelected': address.isSelected,

      'latitude': address.latitude,

      'longitude': address.longitude,
    };
  }

  //============================================================
  // ORDER ITEM → FIRESTORE MAP
  //============================================================

  Map<String, dynamic> _orderItemToMap(dynamic item) {
    return {
      //==========================================================
      // QUANTITY / PRICE
      //==========================================================

      'quantity': item.quantity,

      'unitPrice': item.unitPrice,

      'totalPrice': item.totalPrice,

      'notes': item.notes,

      //==========================================================
      // PRODUCT
      //==========================================================
      'product': item.product != null
          ? {
              'id': item.product!.id,

              'name': item.product!.name,

              'image': item.product!.image,

              'category': item.product!.category,
            }
          : null,

      //==========================================================
      // PRODUCT VARIANT
      //==========================================================
      'variant': item.variant != null
          ? {
              'id': item.variant!.id,

              'name': item.variant!.name,

              'price': item.variant!.price,
            }
          : null,

      //==========================================================
      // SPECIAL DEAL
      //==========================================================
      'specialDeal': item.specialDeal != null
          ? {
              'id': item.specialDeal!.id,

              'title': item.specialDeal!.title,

              'description': item.specialDeal!.description,

              'bannerImage': item.specialDeal!.bannerImage,

              'squareImage': item.specialDeal!.squareImage,

              'originalPrice': item.specialDeal!.originalPrice,

              'dealPrice': item.specialDeal!.dealPrice,

              'discount': item.specialDeal!.discount,

              'specialNote': item.specialDeal!.specialNote,
            }
          : null,
    };
  }

  //============================================================
  // RIDER → FIRESTORE MAP
  //============================================================

  Map<String, dynamic> _riderToMap(OrderModel order) {
    final rider = order.rider!;

    return {
      'id': rider.id,

      'name': rider.name,

      'phone': rider.phone,

      'profileImage': rider.profileImage,

      'vehicleType': rider.vehicleType,

      'vehicleNumber': rider.vehicleNumber,

      'rating': rider.rating,

      'isAvailable': rider.isAvailable,
    };
  }

  //============================================================
  // UPDATE ORDER STATUS
  //============================================================

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final Map<String, dynamic> data = {
      'status': status.name,

      'updatedAt': FieldValue.serverTimestamp(),
    };

    //==========================================================
    // DELIVERED
    //==========================================================

    if (status == OrderStatus.delivered) {
      data['deliveredAt'] = FieldValue.serverTimestamp();
    }

    await _ordersCollection.doc(orderId).update(data);
  }

  //============================================================
  // UPDATE PAYMENT STATUS
  //============================================================

  Future<void> updatePaymentStatus({
    required String orderId,
    required PaymentStatus status,
  }) async {
    await _ordersCollection.doc(orderId).update({
      'paymentStatus': status.name,

      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // CANCEL ORDER
  //============================================================

  Future<void> cancelOrder(String orderId) async {
    await _ordersCollection.doc(orderId).update({
      'status': OrderStatus.cancelled.name,

      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // GET USER ORDERS
  //============================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserOrders(String userId) {
    if (userId.trim().isEmpty) {
      throw ArgumentError('User ID cannot be empty.');
    }

    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .limit(50)
        .snapshots();
  }

  //============================================================
  // GET SINGLE ORDER
  //============================================================

  Future<DocumentSnapshot<Map<String, dynamic>>> getOrder(
    String orderId,
  ) async {
    return await _ordersCollection.doc(orderId).get();
  }

  //============================================================
  // UPDATE ORDER
  //============================================================

  Future<void> updateOrder(String orderId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();

    await _ordersCollection.doc(orderId).update(data);
  }
}
