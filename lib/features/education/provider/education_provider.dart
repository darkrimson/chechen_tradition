import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chechen_tradition/data/education/mock_education.dart';
import 'package:chechen_tradition/features/education/models/education.dart';

class EducationProvider with ChangeNotifier {
  List<EducationalContent> _educationalContent = [];
  Map<String, double> _progressMap = {}; // ID контента -> прогресс (0.0-1.0)
  Map<String, List<String>> _answeredQuestions =
      {}; // ID контента -> список ID отвеченных вопросов

  EducationProvider() {
    _initEducation();
  }

  // Геттеры
  List<EducationalContent> get educationalContent => _educationalContent;

  // Получение контента по ID
  EducationalContent? getContentById(String id) {
    try {
      return _educationalContent.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Инициализация данных
  Future<void> _initEducation() async {
    // Загрузка мок-данных
    _educationalContent = List.from(mockEducationalContent);

    // Загрузка прогресса обучения
    await _loadProgress();

    // Обновление прогресса для всех материалов
    _updateProgress();

    notifyListeners();
  }

  // Загрузка прогресса из SharedPreferences
  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Загрузка общего прогресса
      final String? progressJson = prefs.getString('education_progress');
      if (progressJson != null) {
        final Map<String, dynamic> progressData = jsonDecode(progressJson);
        _progressMap = Map<String, double>.from(
            progressData.map((key, value) => MapEntry(key, value as double)));
      }

      // Загрузка отвеченных вопросов
      final String? answeredJson =
          prefs.getString('education_answered_questions');
      if (answeredJson != null) {
        final Map<String, dynamic> answeredData = jsonDecode(answeredJson);
        _answeredQuestions = Map<String, List<String>>.from(answeredData
            .map((key, value) => MapEntry(key, List<String>.from(value))));
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке прогресса обучения: $e');
    }
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
  void _updateProgress() {
    for (var content in _educationalContent) {
      // Установка прогресса из сохраненных данных
      if (_progressMap.containsKey(content.id)) {
        final progress = _progressMap[content.id] ?? 0.0;
        content = EducationalContent(
          id: content.id,
          title: content.title,
          description: content.description,
          content: content.content,
          imageUrl: content.imageUrl,
          questions: content.questions,
          progress: progress,
          isCompleted: progress >= 1.0,
        );
      }

      // Обновление статуса ответов на вопросы
      if (_answeredQuestions.containsKey(content.id)) {
        final answeredIds = _answeredQuestions[content.id] ?? [];
        for (var question in content.questions) {
          if (answeredIds.contains(question.id)) {
            question.isAnswered = true;
          }
        }
      }
    }
  }

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
      _educationalContent[contentIndex] = EducationalContent(
        id: content.id,
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
      _educationalContent[contentIndex] = EducationalContent(
        id: content.id,
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
