import 'package:chechen_tradition/features/education/models/question.dart';
import 'package:flutter/material.dart';
import '../../models/education.dart';

class TestScreen extends StatefulWidget {
  final Education content;

  const TestScreen({
    super.key,
    required this.content,
  });

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  late List<Question> _questions;

  @override
  void initState() {
    super.initState();
    // Создаем копию вопросов, чтобы не менять оригинальные данные
    _questions = widget.content.questions
        .map((q) => Question(
              id: q.id,
              question: q.question,
              options: q.options,
              correctAnswerIndex: q.correctAnswerIndex,
              isAnswered: false,
              isCorrect: null,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Вопрос ${_currentQuestionIndex + 1}/${_questions.length}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[200],
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            minHeight: 6,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.question_mark,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.question,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                        child: Row(
                          children: [
                            Text(
                              '${String.fromCharCode(65 + index)}.',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                question.options[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            if (question.isAnswered)
                              Icon(
                                index == question.correctAnswerIndex
                                    ? Icons.check_circle
                                    : (question.isCorrect == false &&
                                            index ==
                                                question.correctAnswerIndex)
                                        ? Icons.check_circle
                                        : null,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (question.isAnswered)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: question.isCorrect!
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.isCorrect! ? 'Правильно!' : 'Неправильно!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: question.isCorrect! ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _goToNextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
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
                ],
              ),
            ),
        ],
      ),
    );
  }

  bool get _isLastQuestion => _currentQuestionIndex == _questions.length - 1;

  Color _getOptionColor(Question question, int optionIndex) {
    if (!question.isAnswered) return Theme.of(context).primaryColor;

    if (optionIndex == question.correctAnswerIndex) {
      return Colors.green;
    }

    if (!question.isCorrect! && optionIndex == question.correctAnswerIndex) {
      return Colors.green;
    }

    return Theme.of(context).primaryColor;
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
    final percentage = (_correctAnswers / _questions.length * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Результаты теста'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: percentage >= 70 ? Colors.green : Colors.orange,
              child: Icon(
                percentage >= 70 ? Icons.check : Icons.priority_high,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Правильных ответов: $_correctAnswers из ${_questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              'Процент успеха: $percentage%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
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
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // закрыть диалог
              _restartTest(); // перезапустить тест
            },
            style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Пройти снова'),
          ),
        ],
      ),
    );
  }

  // Метод для перезапуска теста
  void _restartTest() {
    setState(() {
      _currentQuestionIndex = 0;
      _correctAnswers = 0;

      // Сбрасываем состояние всех вопросов
      for (var question in _questions) {
        question.isAnswered = false;
        question.isCorrect = null;
      }
    });
  }
}
