import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tradition.dart';

class TraditionProvider with ChangeNotifier {
  List<Tradition> _traditions = [];
  List<String> _favoriteIds = [];
  TraditionCategory? _selectedFilter;

  TraditionProvider() {
    _initTraditions();
  }

  // Геттеры
  List<Tradition> get traditions => _traditions;
  TraditionCategory? get selectedFilter => _selectedFilter;

  // Проверка избранного статуса
  bool isFavorite(String id) => _favoriteIds.contains(id);

  // Получение списка избранных традиций
  List<Tradition> getFavoriteTraditions() {
    return _traditions.where((tradition) => isFavorite(tradition.id)).toList();
  }

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
    try {
      final response =
          await Supabase.instance.client.from('traditions').select('*');

      final data = response as List<dynamic>;
      print('Supabase raw data: $data');

      _traditions = data.map((item) => Tradition.fromMap(item)).toList();
    } catch (e) {
      debugPrint('Ошибка загрузки мест из Supabase: $e');
      // fallback на моки
    }

    await _loadFavorites();
    notifyListeners();
  }

  // Загрузка избранного из SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _favoriteIds = prefs.getStringList('favorites') ?? [];
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

  // Переключение избранного
  Future<void> toggleFavorite(String traditionId) async {
    if (_favoriteIds.contains(traditionId)) {
      _favoriteIds.remove(traditionId);
    } else {
      _favoriteIds.add(traditionId);
    }
    await _saveFavorites();
    notifyListeners();
  }

  void setFilter(TraditionCategory? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Tradition? getTraditionById(String id) {
    try {
      return _traditions.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}
