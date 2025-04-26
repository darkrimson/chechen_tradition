class EducationalContent {
  final String id;
  final String title;
  final String description;
  final String? content;
  final String imageUrl;
  final List<String> images;
  final List<Question> questions;
  final bool isCompleted;
  final double progress;

  EducationalContent({
    required this.images,
    required this.id,
    required this.title,
    required this.description,
    this.content,
    required this.imageUrl,
    required this.questions,
    this.isCompleted = false,
    this.progress = 0.0,
  });
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  bool isAnswered;
  bool? isCorrect;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.isAnswered = false,
    this.isCorrect,
  });
}
