import 'dart:convert';
import 'package:chechen_tradition/features/education/models/question.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chechen_tradition/features/education/models/education.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EducationProvider with ChangeNotifier {
  final List<Education> _educationalContent = [];
  final Map<String, double> _progressMap =
      {}; // ID контента -> прогресс (0.0-1.0)
  final Map<String, List<String>> _answeredQuestions =
      {}; // ID контента -> список ID отвеченных вопросов

  EducationProvider() {
    loadEducationData();
  }

  // Геттеры
  List<Education> get educationalContent => _educationalContent;

  // Получение контента по ID
  Education? getContentById(String id) {
    try {
      return _educationalContent.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Инициализация данных
  Future<void> loadEducationData() async {
    final supabase = Supabase.instance.client;

    // 1. Получаем все материалы
    final educationRes = await supabase.from('education').select('*');

    // 2. Получаем все вопросы
    final questionsRes = await supabase.from('question').select('*');

    // 3. Группируем вопросы по education_id
    final Map<String, List<Question>> questionMap = {};
    for (var item in questionsRes) {
      final question = Question.fromMap(item);
      final educationId = item['id'];
      if (!questionMap.containsKey(educationId)) {
        questionMap[educationId] = [];
      }
      questionMap[educationId]!.add(question);
    }

    _educationalContent.clear();

    // 4. Собираем все в Education
    for (var item in educationRes) {
      final questions = questionMap[item['id']] ?? [];
      final education = Education.fromMap(item, questions);
      _educationalContent.add(education);
    }

    notifyListeners();
  }

  // Сохранение прогресса в SharedPreferences
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Сохранение общего прогресса
      await prefs.setString('education_progress', jsonEncode(_progressMap));

      // Сохранение отвеченных вопросов
      await prefs.setString(
          'education_answered_questions', jsonEncode(_answeredQuestions));
    } catch (e) {
      debugPrint('Ошибка при сохранении прогресса обучения: $e');
    }
  }

  // Обновление статуса прогресса для всех образовательных материалов

  // Сохранение ответа на вопрос
  Future<void> saveQuestionAnswer(
      String contentId, String questionId, bool isCorrect) async {
    // Находим контент
    final contentIndex =
        _educationalContent.indexWhere((item) => item.id == contentId);
    if (contentIndex < 0) return;

    final content = _educationalContent[contentIndex];

    // Находим вопрос
    final questionIndex =
        content.questions.indexWhere((q) => q.id == questionId);
    if (questionIndex < 0) return;

    // Отмечаем вопрос как отвеченный
    content.questions[questionIndex].isAnswered = true;
    content.questions[questionIndex].isCorrect = isCorrect;

    // Обновляем список отвеченных вопросов
    if (!_answeredQuestions.containsKey(contentId)) {
      _answeredQuestions[contentId] = [];
    }

    if (!_answeredQuestions[contentId]!.contains(questionId)) {
      _answeredQuestions[contentId]!.add(questionId);
    }

    // Пересчитываем прогресс
    _recalculateProgress(contentId);

    // Сохраняем изменения
    await _saveProgress();

    notifyListeners();
  }

  // Пересчет прогресса для конкретного образовательного материала
  void _recalculateProgress(String contentId) {
    final contentIndex =
        _educationalContent.indexWhere((item) => item.id == contentId);
    if (contentIndex < 0) return;

    final content = _educationalContent[contentIndex];
    final answeredCount = _answeredQuestions[contentId]?.length ?? 0;
    final totalQuestions = content.questions.length;

    if (totalQuestions > 0) {
      final progress = answeredCount / totalQuestions;
      _progressMap[contentId] = progress;

      // Обновляем прогресс в объекте контента
      _educationalContent[contentIndex] = Education(
        id: content.id,
        images: content.images,
        title: content.title,
        description: content.description,
        content: content.content,
        imageUrl: content.imageUrl,
        questions: content.questions,
        progress: progress,
        isCompleted: progress >= 1.0,
      );
    }
  }

  // Сброс прогресса для конкретного материала
  Future<void> resetProgress(String contentId) async {
    // Удаляем данные о прогрессе
    _progressMap.remove(contentId);
    _answeredQuestions.remove(contentId);

    // Находим и сбрасываем состояние контента
    final contentIndex =
        _educationalContent.indexWhere((item) => item.id == contentId);
    if (contentIndex >= 0) {
      final content = _educationalContent[contentIndex];

      // Сбрасываем состояние вопросов
      for (var question in content.questions) {
        question.isAnswered = false;
        question.isCorrect = null;
      }

      // Обновляем объект с нулевым прогрессом
      _educationalContent[contentIndex] = Education(
        id: content.id,
        images: content.images,
        title: content.title,
        description: content.description,
        content: content.content,
        imageUrl: content.imageUrl,
        questions: content.questions,
        progress: 0.0,
        isCompleted: false,
      );
    }

    // Сохраняем изменения
    await _saveProgress();

    notifyListeners();
  }
}
