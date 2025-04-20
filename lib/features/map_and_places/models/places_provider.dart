import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chechen_tradition/data/places/mock_places.dart';
import 'package:chechen_tradition/features/map_and_places/models/culture_place.dart';

class PlacesProvider with ChangeNotifier {
  List<CulturalPlace> _places = [];
  List<String> _favoritePlaceNames =
      []; // Имена избранных мест (используем имя как ID)
  PlaceType? _selectedFilter;
  bool _showMapView = false; // Показывать карту (false) или список (true)

  PlacesProvider() {
    _initPlaces();
  }

  // Геттеры
  List<CulturalPlace> get places => _places;

  List<CulturalPlace> get favoritePlaces => _places
      .where((place) => _favoritePlaceNames.contains(place.name))
      .toList();

  PlaceType? get selectedFilter => _selectedFilter;

  bool get showMapView => _showMapView;

  // Фильтрованные места
  List<CulturalPlace> getFilteredPlaces() {
    if (_selectedFilter == null) {
      return _places;
    }
    return _places.where((place) => place.type == _selectedFilter).toList();
  }

  // Инициализация данных
  Future<void> _initPlaces() async {
    // Загрузка мок-данных
    _places = mockPlaces;

    // Загрузка избранного из SharedPreferences
    await _loadFavorites();

    notifyListeners();
  }

  // Загрузка избранного из SharedPreferences
  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? favoritesList =
          prefs.getStringList('favorite_places');
      if (favoritesList != null) {
        _favoritePlaceNames = favoritesList;
      }
    } catch (e) {
      debugPrint('Ошибка при загрузке избранных мест: $e');
    }
  }

  // Сохранение избранного в SharedPreferences
  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_places', _favoritePlaceNames);
    } catch (e) {
      debugPrint('Ошибка при сохранении избранных мест: $e');
    }
  }

  // Переключение избранного для места
  Future<void> toggleFavorite(String placeName) async {
    if (_favoritePlaceNames.contains(placeName)) {
      _favoritePlaceNames.remove(placeName);
    } else {
      _favoritePlaceNames.add(placeName);
    }

    // Сохраняем изменения
    await _saveFavorites();

    notifyListeners();
  }

  // Проверка, является ли место избранным
  bool isFavorite(String placeName) {
    return _favoritePlaceNames.contains(placeName);
  }

  // Установка фильтра категории
  void setFilter(PlaceType? filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  // Переключение между картой и списком
  void toggleView() {
    _showMapView = !_showMapView;
    notifyListeners();
  }

  // Получение места по имени
  CulturalPlace? getPlaceByName(String name) {
    try {
      return _places.firstWhere((place) => place.name == name);
    } catch (e) {
      return null;
    }
  }
}
