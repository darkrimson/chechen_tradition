import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chechen_tradition/data/traditions/mock_traditions.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';

class TraditionProvider with ChangeNotifier {
  List<Tradition> _traditions = [];
  List<String> _favoriteIds = [];
  TraditionCategory? _selectedFilter;

  TraditionProvider() {
    _initTraditions();
  }

  // Геттеры
  List<Tradition> get traditions => _traditions;

  List<Tradition> get favoriteTraditions => _traditions
      .where((tradition) => _favoriteIds.contains(tradition.id))
      .toList();

  TraditionCategory? get selectedFilter => _selectedFilter;

  // Фильтрованные традиции
  List<Tradition> getFilteredTraditions() {
    if (_selectedFilter == null) {
      return _traditions;
    }
    return _traditions
        .where((tradition) => tradition.category == _selectedFilter)
        .toList();
  }

  // Инициализация данных
  Future<void> _initTraditions() async {
    // Загрузка мок-данных
    _traditions = mockTraditions;

    // Загрузка избранного из SharedPreferences
    await _loadFavorites();

    // Обновление статуса избранного для загруженных традиций
    _updateFavoritesStatus();

    notifyListeners();
  }

  // Загрузка избранного из SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favoritesList = prefs.getStringList('favorites');
      if (favoritesList != null) {
        _favoriteIds = favoritesList;
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке избранного: $e');
    }
  }

  // Сохранение избранного в SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _favoriteIds);
    } catch (e) {
      debugPrint('Ошибка при сохранении избранного: $e');
    }
  }

  // Обновление статуса избранного для всех традиций
  void _updateFavoritesStatus() {
    for (var tradition in _traditions) {
      tradition.isLiked = _favoriteIds.contains(tradition.id);
    }
  }

  // Переключение избранного для традиции
  Future<void> toggleFavorite(String traditionId) async {
    final index = _traditions.indexWhere((t) => t.id == traditionId);
    if (index >= 0) {
      // Переключаем статус
      final isCurrentlyLiked = _traditions[index].isLiked;
      _traditions[index].isLiked = !isCurrentlyLiked;

      // Обновляем список ID избранного
      if (_traditions[index].isLiked) {
        if (!_favoriteIds.contains(traditionId)) {
          _favoriteIds.add(traditionId);
        }
      } else {
        _favoriteIds.remove(traditionId);
      }

      // Сохраняем изменения
      await _saveFavorites();

      notifyListeners();
    }
  }

  // Установка фильтра категории
  void setFilter(TraditionCategory? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Получение традиции по ID
  Tradition? getTraditionById(String id) {
    try {
      return _traditions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
