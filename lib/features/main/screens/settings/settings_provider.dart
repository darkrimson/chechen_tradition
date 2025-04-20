import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // Настройки приложения
  bool _useGeolocation = true;
  bool _offlineMaps = false;
  bool _notifications = true;
  String _language = 'ru'; // По умолчанию русский

  // Геттеры
  bool get useGeolocation => _useGeolocation;
  bool get offlineMaps => _offlineMaps;
  bool get notifications => _notifications;
  String get language => _language;

  SettingsProvider() {
    _loadSettings();
  }

  // Загрузка настроек из SharedPreferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _useGeolocation = prefs.getBool('use_geolocation') ?? true;
      _offlineMaps = prefs.getBool('offline_maps') ?? false;
      _notifications = prefs.getBool('notifications') ?? true;
      _language = prefs.getString('language') ?? 'ru';

      notifyListeners();
    } catch (e) {
      debugPrint('Ошибка при загрузке настроек: $e');
    }
  }

  // Сохранение настроек
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('use_geolocation', _useGeolocation);
      await prefs.setBool('offline_maps', _offlineMaps);
      await prefs.setBool('notifications', _notifications);
      await prefs.setString('language', _language);
    } catch (e) {
      debugPrint('Ошибка при сохранении настроек: $e');
    }
  }

  // Методы для изменения настроек
  Future<void> setUseGeolocation(bool value) async {
    _useGeolocation = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setOfflineMaps(bool value) async {
    _offlineMaps = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    _notifications = value;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _saveSettings();
    notifyListeners();
  }

  // Очистка кэша
  Future<void> clearCache() async {
    // Здесь была бы реализация очистки кэша приложения
    // Для демонстрационных целей просто вызываем notifyListeners
    notifyListeners();
  }
}
