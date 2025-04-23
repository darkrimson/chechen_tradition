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
  clothing('Одежда', 'https://www.svgrepo.com/show/482520/clothes-hanger.svg'),
  cuisine('Кухня', 'https://www.svgrepo.com/show/490738/food-restaurant.svg'),
  crafts('Ремесла',
      'https://www.svgrepo.com/show/425780/craft-knitting-tailor.svg'),
  holidays(
      'Праздники', 'https://www.svgrepo.com/show/452246/calendar-marked.svg');

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
      return Colors.amber.shade800;
    case TraditionCategory.holidays:
      return Colors.green;
  }
}
