import 'package:chechen_tradition/features/education/models/question.dart';

class Education {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final List<String> images;
  final List<Question> questions;
  final bool isCompleted;
  final double progress;

  Education({
    required this.images,
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.questions,
    this.isCompleted = false,
    this.progress = 0.0,
  });

  factory Education.fromMap(
      Map<String, dynamic> json, List<Question> questions) {
    return Education(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      questions: questions,
    );
  }
}
