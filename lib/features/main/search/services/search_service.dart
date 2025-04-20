import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chechen_tradition/data/places/mock_places.dart';
import 'package:chechen_tradition/data/traditions/mock_traditions.dart';
import 'package:chechen_tradition/data/education/mock_education.dart';
import '../models/search_result.dart';

class SearchService {
  // Ключ для хранения истории в SharedPreferences
  static const String _historyKey = 'search_history';

  // Выполнение поиска по заданному запросу
  Future<List<SearchResult>> search(String query) async {
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase();
    final results = <SearchResult>[];

    try {
      // Поиск среди мест
      results.addAll(_searchPlaces(normalizedQuery));

      // Поиск среди традиций
      results.addAll(_searchTraditions(normalizedQuery));

      // Поиск среди образовательного контента
      results.addAll(_searchEducation(normalizedQuery));

      // Автоматически сохраняем запрос в историю при успешном поиске
      await saveToHistory(query);
    } catch (e) {
      debugPrint('Ошибка при выполнении поиска: $e');
    }

    return results;
  }

  // Выполнение поиска без сохранения в историю (для поиска при вводе текста)
  Future<List<SearchResult>> searchWithoutSaving(String query) async {
    if (query.isEmpty) return [];

    final normalizedQuery = query.toLowerCase();
    final results = <SearchResult>[];

    try {
      // Поиск среди мест
      results.addAll(_searchPlaces(normalizedQuery));

      // Поиск среди традиций
      results.addAll(_searchTraditions(normalizedQuery));

      // Поиск среди образовательного контента
      results.addAll(_searchEducation(normalizedQuery));
    } catch (e) {
      debugPrint('Ошибка при выполнении поиска без сохранения: $e');
    }

    return results;
  }

  // Поиск среди мест
  List<SearchResult> _searchPlaces(String query) {
    return mockPlaces
        .where((place) =>
            place.name.toLowerCase().contains(query) ||
            place.description.toLowerCase().contains(query))
        .map((place) => SearchResult(
              id: place.name,
              title: place.name,
              description: place.description,
              imageUrl: place.imageUrl,
              type: SearchResultType.place,
              originalItem: place,
            ))
        .toList();
  }

  // Поиск среди традиций
  List<SearchResult> _searchTraditions(String query) {
    return mockTraditions
        .where((tradition) =>
            tradition.title.toLowerCase().contains(query) ||
            tradition.description.toLowerCase().contains(query))
        .map((tradition) => SearchResult(
              id: tradition.id,
              title: tradition.title,
              description: tradition.description,
              imageUrl: tradition.imageUrl,
              type: SearchResultType.tradition,
              originalItem: tradition,
            ))
        .toList();
  }

  // Поиск среди образовательного контента
  List<SearchResult> _searchEducation(String query) {
    return mockEducationalContent
        .where((content) =>
            content.title.toLowerCase().contains(query) ||
            content.description.toLowerCase().contains(query))
        .map((content) => SearchResult(
              id: content.id,
              title: content.title,
              description: content.description,
              imageUrl: content.imageUrl,
              type: SearchResultType.education,
              originalItem: content,
            ))
        .toList();
  }

  // Получение истории поиска из SharedPreferences
  Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? history = prefs.getStringList(_historyKey);

      if (history == null) {
        return [];
      }

      return history;
    } catch (e) {
      debugPrint('Ошибка при получении истории поиска: $e');
      return [];
    }
  }

  // Сохранение запроса в историю поиска в SharedPreferences
  Future<void> saveToHistory(String query) async {
    if (query.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      // Получаем текущую историю
      List<String> history = [];
      final List<String>? savedHistory = prefs.getStringList(_historyKey);

      if (savedHistory != null) {
        history = savedHistory;
      }

      // Удаляем дубликаты и добавляем новый запрос в начало
      if (history.contains(query)) {
        history.remove(query);
      }
      history.insert(0, query);

      // Ограничиваем историю 10 элементами
      if (history.length > 10) {
        history.removeLast();
      }

      // Сохраняем обновленную историю
      await prefs.setStringList(_historyKey, history);
      debugPrint('История поиска сохранена в SharedPreferences');
    } catch (e) {
      debugPrint('Ошибка при сохранении истории поиска: $e');
    }
  }

  // Очистка истории поиска в SharedPreferences
  Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      debugPrint('История поиска очищена из SharedPreferences');
    } catch (e) {
      debugPrint('Ошибка при очистке истории поиска: $e');
    }
  }
}
