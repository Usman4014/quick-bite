// ignore_for_file: file_names

import 'package:latlong2/latlong.dart';

class DeliveryZoneModel {
  final String id;
  final String title;

  /// Polygon points that define the geographic
  /// boundary of this delivery zone.
  final List<LatLng> boundaryPoints;

  const DeliveryZoneModel({
    required this.id,
    required this.title,
    required this.boundaryPoints,
  });
}