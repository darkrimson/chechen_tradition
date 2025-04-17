import 'package:flutter/material.dart';

class Tradition {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final TraditionCategory category;
  bool isLiked;

  Tradition({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.category,
    this.isLiked = false,
  });
}

enum TraditionCategory {
  clothing('Одежда', Icons.person),
  cuisine('Кухня', Icons.restaurant),
  crafts('Ремесла', Icons.handshake),
  holidays('Праздники', Icons.holiday_village);

  final String label;
  final IconData iconPath;
  const TraditionCategory(this.label, this.iconPath);
}
