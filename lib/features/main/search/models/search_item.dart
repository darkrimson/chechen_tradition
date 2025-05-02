// lib/models/search_item.dart
import 'package:chechen_tradition/features/education/models/education.dart';
import 'package:chechen_tradition/features/education/models/question.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';

enum SearchItemType { place, tradition, education }

class SearchItem {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final SearchItemType type;
  final dynamic originalItem;

  SearchItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.type,
    required this.originalItem,
  });

  factory SearchItem.fromPlace(CulturalPlace place) {
    return SearchItem(
      id: '',
      title: place.name,
      subtitle: place.description,
      imageUrl: place.imageUrl,
      type: SearchItemType.place,
      originalItem: place,
    );
  }

  factory SearchItem.fromTradition(Tradition tradition) {
    return SearchItem(
      id: tradition.id,
      title: tradition.name,
      subtitle: tradition.description,
      imageUrl: tradition.imageUrl,
      type: SearchItemType.tradition,
      originalItem: tradition,
    );
  }

  factory SearchItem.fromEducation(Education education) {
    return SearchItem(
      id: education.id,
      title: education.title,
      subtitle: education.description,
      imageUrl: education.imageUrl,
      type: SearchItemType.education,
      originalItem: education,
    );
  }
}
