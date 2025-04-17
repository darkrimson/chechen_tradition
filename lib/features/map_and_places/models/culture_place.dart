import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

class CulturalPlace {
  final String name;
  final String description;
  final Point location;
  final PlaceType type;
  final String? imageUrl;

  CulturalPlace({
    required this.name,
    required this.description,
    required this.location,
    required this.type,
    this.imageUrl,
  });
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

IconData getIconForType(PlaceType type) {
  switch (type) {
    case PlaceType.museum:
      return Icons.museum;
    case PlaceType.monument:
      return Icons.account_balance;
    case PlaceType.nature:
      return Icons.landscape;
    case PlaceType.architecture:
      return Icons.architecture;
  }
}
