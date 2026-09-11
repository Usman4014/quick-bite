// ignore_for_file: file_names

class RiderModel {
  final String id;

  /// Rider's full name
  final String name;

  /// Rider's phone number
  final String phone;

  /// Rider's profile image
  final String profileImage;

  /// Vehicle used for deliveries
  final String vehicleType;

  /// Vehicle registration/number
  final String vehicleNumber;

  /// Rider's average rating
  final double rating;

  /// Whether rider is currently available for a new order
  bool isAvailable;

  RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.profileImage,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.rating,
    this.isAvailable = true,
  });
}