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
  final String imageUrl;
  final List<String>? images;

  CulturalPlace({
    required this.name,
    required this.description,
    required this.location,
    required this.type,
    required this.imageUrl,
    this.images,
  });

  // Преобразование координат в LatLng для flutter_map
  LatLng get latLng => location.toLatLng();

  factory CulturalPlace.fromMap(Map<String, dynamic> json) {
    return CulturalPlace(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: GeoPoint(
        latitude: json['latitude']?.toDouble() ?? 0.0,
        longitude: json['longitude']?.toDouble() ?? 0.0,
      ),
      type: PlaceType.values.firstWhere(
        (e) => e.name.toString() == json['type'],
        orElse: () => PlaceType.museum,
      ),
      imageUrl: json['image_url'] ?? '',
      images: (() {
        final raw = json['images'];
        if (raw is List) {
          return raw.map((e) => e.toString()).toList();
        } else if (raw is String && raw.contains(',')) {
          return raw.split(',').map((e) => e.trim()).toList();
        } else if (raw is String && raw.trim().isNotEmpty) {
          return [raw.trim()];
        } else {
          return null;
        }
      })(),
    );
  }
}

enum PlaceType {
  museum('Музеи', 'https://www.svgrepo.com/show/490879/museum.svg'),
  monument(
      'Памятники', 'https://www.svgrepo.com/show/179039/obelisk-monument.svg'),
  nature('Природа', 'https://www.svgrepo.com/show/476077/mountain.svg'),
  architecture(
      'Архитектура', 'https://www.svgrepo.com/show/428234/architecture.svg');

  final String label;
  final String networkSvg;
  const PlaceType(this.label, this.networkSvg);
}

Color getCategoryColor(PlaceType category) {
  switch (category) {
    case PlaceType.museum:
      return Colors.blue;
    case PlaceType.monument:
      return Colors.orange;
    case PlaceType.nature:
      return Colors.green;
    case PlaceType.architecture:
      return Colors.red;
  }
}
