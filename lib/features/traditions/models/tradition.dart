import 'package:flutter/material.dart';

class Tradition {
  final String id;
  final String name;
  final String description;
  final String content;
  final String imageUrl;
  final TraditionCategory category;

  Tradition({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.category,
  });

  factory Tradition.fromMap(Map<String, dynamic> json) {
    return Tradition(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      imageUrl: json['image_url'] as String,
      category: TraditionCategory.values.firstWhere(
        (e) => e.name.toString() == json['category'],
        orElse: () => TraditionCategory.clothing,
      ),
    );
  }
}

enum TraditionCategory {
  clothing('Одежда', 'https://www.svgrepo.com/show/482520/clothes-hanger.svg'),
  cuisine('Кухня', 'https://www.svgrepo.com/show/490738/food-restaurant.svg'),
  crafts('Ремесла',
      'https://www.svgrepo.com/show/425780/craft-knitting-tailor.svg'),
  holidays(
      'События', 'https://www.svgrepo.com/show/452246/calendar-marked.svg');

  final String label;
  final String networkSvg;
  const TraditionCategory(this.label, this.networkSvg);
}

Color getCategoryColor(TraditionCategory category) {
  switch (category) {
    case TraditionCategory.clothing:
      return Colors.blue;
    case TraditionCategory.cuisine:
      return Colors.orange;
    case TraditionCategory.crafts:
      return Colors.red;
    case TraditionCategory.holidays:
      return Colors.green;
  }
}
