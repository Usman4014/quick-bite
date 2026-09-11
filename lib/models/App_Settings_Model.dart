// ignore_for_file: file_names

class AppSettingsModel {
  //============================================================
  // RESTAURANT INFORMATION
  //============================================================

  final String restaurantName;

  final String restaurantPhone;

  final String restaurantEmail;

  final String restaurantAddress;
  final double restaurantLatitude;
  final double restaurantLongitude;

  //============================================================
  // DELIVERY
  //============================================================

  final double deliveryRadius;

  final double deliveryFee;

  final double minimumOrderAmount;

  final int estimatedDeliveryMinutes;

  //============================================================
  // ORDERS
  //============================================================

  final bool acceptOrders;

  final bool allowCancellation;

  final int preparationTimeMinutes;

  //============================================================
  // PAYMENTS
  //============================================================

  final bool cashOnDelivery;

  final bool onlinePayment;

  //============================================================
  // NOTIFICATIONS
  //============================================================

  final bool newOrderNotifications;

  final bool orderStatusNotifications;

  //============================================================
  // APP
  //============================================================

  final bool maintenanceMode;

  final bool appAvailable;

  //============================================================
  // CONSTRUCTOR
  //============================================================

  const AppSettingsModel({
    required this.restaurantName,
    required this.restaurantPhone,
    required this.restaurantEmail,
    required this.restaurantAddress,
    required this.restaurantLatitude,
    required this.restaurantLongitude,
    required this.deliveryRadius,
    required this.deliveryFee,
    required this.minimumOrderAmount,
    required this.estimatedDeliveryMinutes,
    required this.acceptOrders,
    required this.allowCancellation,
    required this.preparationTimeMinutes,
    required this.cashOnDelivery,
    required this.onlinePayment,
    required this.newOrderNotifications,
    required this.orderStatusNotifications,
    required this.maintenanceMode,
    required this.appAvailable,
  });

  //============================================================
  // DEFAULT SETTINGS
  //============================================================

  factory AppSettingsModel.defaults() {
    return const AppSettingsModel(
      restaurantName: 'Quick Bite',
      restaurantPhone: '',
      restaurantEmail: '',
      restaurantAddress: '',
      restaurantLatitude: 0.0,
      restaurantLongitude: 0.0,
      deliveryRadius: 10.0,
      deliveryFee: 0.0,
      minimumOrderAmount: 0.0,
      estimatedDeliveryMinutes: 30,
      acceptOrders: true,
      allowCancellation: true,
      preparationTimeMinutes: 20,
      cashOnDelivery: true,
      onlinePayment: false,
      newOrderNotifications: true,
      orderStatusNotifications: true,
      maintenanceMode: false,
      appAvailable: true,
    );
  }

  //============================================================
  // COPY WITH
  //============================================================

  AppSettingsModel copyWith({
    String? restaurantName,
    String? restaurantPhone,
    String? restaurantEmail,
    String? restaurantAddress,
    double? deliveryRadius,
    double? deliveryFee,
    double? minimumOrderAmount,
    int? estimatedDeliveryMinutes,
    bool? acceptOrders,
    bool? allowCancellation,
    int? preparationTimeMinutes,
    bool? cashOnDelivery,
    bool? onlinePayment,
    bool? newOrderNotifications,
    bool? orderStatusNotifications,
    bool? maintenanceMode,
    bool? appAvailable,
    double? restaurantLatitude,
    double? restaurantLongitude,
  }) {
    return AppSettingsModel(
      restaurantName: restaurantName ?? this.restaurantName,

      restaurantPhone: restaurantPhone ?? this.restaurantPhone,

      restaurantEmail: restaurantEmail ?? this.restaurantEmail,

      restaurantAddress: restaurantAddress ?? this.restaurantAddress,

      restaurantLatitude: restaurantLatitude ?? this.restaurantLatitude,

      restaurantLongitude: restaurantLongitude ?? this.restaurantLongitude,

      deliveryRadius: deliveryRadius ?? this.deliveryRadius,

      deliveryFee: deliveryFee ?? this.deliveryFee,

      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,

      estimatedDeliveryMinutes:
          estimatedDeliveryMinutes ?? this.estimatedDeliveryMinutes,

      acceptOrders: acceptOrders ?? this.acceptOrders,

      allowCancellation: allowCancellation ?? this.allowCancellation,

      preparationTimeMinutes:
          preparationTimeMinutes ?? this.preparationTimeMinutes,

      cashOnDelivery: cashOnDelivery ?? this.cashOnDelivery,

      onlinePayment: onlinePayment ?? this.onlinePayment,

      newOrderNotifications:
          newOrderNotifications ?? this.newOrderNotifications,

      orderStatusNotifications:
          orderStatusNotifications ?? this.orderStatusNotifications,

      maintenanceMode: maintenanceMode ?? this.maintenanceMode,

      appAvailable: appAvailable ?? this.appAvailable,
    );
  }
}
