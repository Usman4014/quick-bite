// ignore_for_file: file_names

class PromoCodeModel {
  /// Unique ID
  String id;

  /// Promo code
  ///
  /// Example:
  /// WELCOME20
  String code;

  /// Promo title
  String title;

  /// Short description
  String description;

  /// Percentage discount
  ///
  /// Example: 20%
  double? discountPercentage;

  /// Flat discount
  ///
  /// Example: Rs.100 OFF
  double? discountAmount;

  /// Minimum order amount
  double minimumOrderAmount;

  /// First order only?
  bool firstOrderOnly;

  /// Is promo code active?
  bool isActive;

  /// Start date
  DateTime startDate;

  /// Expiry date
  DateTime endDate;

  PromoCodeModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    this.discountPercentage,
    this.discountAmount,
    required this.minimumOrderAmount,
    this.firstOrderOnly = false,
    this.isActive = true,
    required this.startDate,
    required this.endDate,
  });
}
