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

  factory Question.fromMap(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correct_answer_index'] ?? 0,
    );
  }
}
