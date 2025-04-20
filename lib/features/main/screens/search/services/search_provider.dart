import 'package:flutter/material.dart';
import '../models/search_result.dart';
import '../services/search_service.dart';

class SearchProvider with ChangeNotifier {
  final SearchService _searchService = SearchService();
  List<SearchResult> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  String _currentQuery = '';

  // Геттеры
  List<SearchResult> get searchResults => _searchResults;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;

  SearchProvider() {
    _loadSearchHistory();
  }

  // Загрузка истории поиска
  Future<void> _loadSearchHistory() async {
    try {
      _setLoading(true);
      final history = await _searchService.getSearchHistory();

      _searchHistory = history;
      _setLoading(false);
    } catch (e) {
      _searchHistory = [];
      _setLoading(false);
      debugPrint('Ошибка при загрузке истории поиска: $e');
    }
  }

  // Выполнение поиска
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _currentQuery = '';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _currentQuery = query;

    try {
      final results = await _searchService.search(query);
      _searchResults = results;

      // После успешного поиска обновляем историю
      await _loadSearchHistory();
    } catch (e) {
      debugPrint('Ошибка при выполнении поиска: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Сохранение текущего запроса в историю
  Future<void> saveCurrentQueryToHistory() async {
    if (_currentQuery.trim().isEmpty) return;

    try {
      // Сохраняем текущий запрос в историю
      await _searchService.saveToHistory(_currentQuery);

      // Обновляем список истории
      await _loadSearchHistory();
    } catch (e) {
      debugPrint('Ошибка при сохранении запроса в историю: $e');
    }
  }

  // Поиск в реальном времени при вводе текста
  Future<void> searchOnType(String query) async {
    // Если запрос пустой, очищаем результаты
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    // Устанавливаем текущий запрос без индикатора загрузки
    _currentQuery = query;

    try {
      // Используем метод, который не сохраняет запрос в историю
      final results = await _searchService.searchWithoutSaving(query);

      // Обновляем результаты только если текущий запрос совпадает
      // (пользователь мог ввести новые символы пока выполнялся поиск)
      if (_currentQuery == query) {
        _searchResults = results;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка при поиске в реальном времени: $e');
    }
  }

  // Поиск по запросу из истории
  Future<void> searchFromHistory(String historyQuery) async {
    await performSearch(historyQuery);
  }

  // Очистка результатов поиска
  void clearSearch() {
    _searchResults = [];
    _currentQuery = '';
    notifyListeners();
  }

  // Очистка истории поиска
  Future<void> clearHistory() async {
    try {
      await _searchService.clearSearchHistory();
      _searchHistory = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при очистке истории: $e');
    }
  }

  // Вспомогательный метод для установки состояния загрузки
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
