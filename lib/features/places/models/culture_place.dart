import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

// Собственный класс для хранения географических координат
class GeoPoint {
  final double latitude;
  final double longitude;

  const GeoPoint({
    required this.latitude,
    required this.longitude,
  });

  // Преобразование в LatLng для flutter_map
  LatLng toLatLng() => LatLng(latitude, longitude);
}

class CulturalPlace {
  final String name;
  final String description;
  final GeoPoint location;
  final PlaceType type;
  final String? imageUrl;
  final List<String>? images;

  CulturalPlace({
    required this.name,
    required this.description,
    required this.location,
    required this.type,
    this.imageUrl,
    this.images,
  });

  // Преобразование координат в LatLng для flutter_map
  LatLng get latLng => location.toLatLng();
}

enum PlaceType {
  museum('Музеи', Icons.museum),
  monument('Памятники', Icons.monochrome_photos_rounded),
  nature('Природа', Icons.nature),
  architecture('Архитектура', Icons.architecture);

  final String label;
  final IconData icon;
  const PlaceType(this.label, this.icon);
}

Color getCategoryColor(PlaceType category) {
  switch (category) {
    case PlaceType.museum:
      return Colors.blue;
    case PlaceType.monument:
      return Colors.orange;
    case PlaceType.nature:
      return Colors.amber.shade800;
    case PlaceType.architecture:
      return Colors.green;
  }
}
