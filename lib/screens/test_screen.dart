import 'package:flutter/material.dart';
import '../models/education.dart';

class TestScreen extends StatefulWidget {
  final EducationalContent content;

  const TestScreen({
    Key? key,
    required this.content,
  }) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;

  @override
  Widget build(BuildContext context) {
    final question = widget.content.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value:
                (_currentQuestionIndex + 1) / widget.content.questions.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF006400)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Вопрос ${_currentQuestionIndex + 1} из ${widget.content.questions.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(
                    question.options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        onPressed: question.isAnswered
                            ? null
                            : () => _checkAnswer(question, index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getOptionColor(question, index),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          question.options[index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (question.isAnswered)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _goToNextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B0000),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _isLastQuestion ? 'Завершить тест' : 'Следующий вопрос',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool get _isLastQuestion =>
      _currentQuestionIndex == widget.content.questions.length - 1;

  Color _getOptionColor(Question question, int optionIndex) {
    if (!question.isAnswered) return const Color(0xFF8B0000);

    if (optionIndex == question.correctAnswerIndex) {
      return const Color(0xFF006400);
    }

    if (question.isCorrect == false &&
        optionIndex == question.correctAnswerIndex) {
      return Colors.orange;
    }

    return const Color(0xFF8B0000);
  }

  void _checkAnswer(Question question, int selectedIndex) {
    setState(() {
      question.isAnswered = true;
      question.isCorrect = selectedIndex == question.correctAnswerIndex;
      if (question.isCorrect!) {
        _correctAnswers++;
      }
    });
  }

  void _goToNextQuestion() {
    if (_isLastQuestion) {
      _showResults();
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _showResults() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Результаты теста'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Правильных ответов: $_correctAnswers из ${widget.content.questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Процент успеха: ${(_correctAnswers / widget.content.questions.length * 100).round()}%',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // закрыть диалог
              Navigator.of(context).pop(); // вернуться к предыдущему экрану
            },
            child: const Text('Завершить'),
          ),
        ],
      ),
    );
  }
}
