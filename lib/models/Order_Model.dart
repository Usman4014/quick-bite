// ignore_for_file: file_names

import 'package:quick_bite/enums/Order_Staus.dart';
import 'package:quick_bite/enums/Payment_Method.dart';
import 'package:quick_bite/enums/Payment_Status.dart';
import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/models/OrderItem_Model.dart';
import 'package:quick_bite/models/Rider_Model.dart';

class OrderModel {
  String userId;
  String orderId;
  List<OrderItemModel> items;
  AddressModel deliveryAddress;
  OrderStatus status;
  PaymentMethod paymentMethod;
  PaymentStatus paymentStatus;
  double subtotal;
  double deliveryFee;
  double offerDiscount;
  double promoDiscount;
  double tax;
  double totalAmount;
  DateTime orderDate;
  DateTime? estimatedDeliveryTime;
  DateTime? deliveredAt;
  String? promoCode;
  String? notes;
  /// Rider assigned to deliver this order
  RiderModel? rider;

  OrderModel({
    required this.userId,
    required this.orderId,
    required this.items,
    required this.deliveryAddress,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.promoDiscount,
    required this.offerDiscount,
    required this.tax,
    required this.totalAmount,
    required this.orderDate,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    this.promoCode,
    this.notes,
    this.rider
  });
}
