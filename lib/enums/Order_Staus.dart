// ignore_for_file: file_names

enum OrderStatus {
  pending,      // Order placed, waiting for confirmation
  confirmed,    // Restaurant accepted the order
  preparing,    // Food is being prepared
  ready,         // Ready for pickup by rider
  onTheWay,      // Rider is delivering the order
  delivered,     // Successfully delivered
  cancelled,     // Cancelled by customer or restaurant
}