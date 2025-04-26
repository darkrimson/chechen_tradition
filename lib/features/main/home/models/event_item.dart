import 'package:flutter/material.dart';

class EventItem {
  final String title;
  final String description;
  final String date;
  final String imageUrl;
  final Color color;

  EventItem({
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.color,
  });
}
