import 'package:flutter/foundation.dart';

/// Простой класс для хранения данных в памяти приложения
class MemoryStorage {
  // Синглтон для доступа к хранилищу
  static final MemoryStorage _instance = MemoryStorage._internal();

  factory MemoryStorage() {
    return _instance;
  }

  MemoryStorage._internal();

  // Внутреннее хранилище данных в памяти
  final Map<String, dynamic> _storage = {};

  /// Сохранить данные по ключу
  void save(String key, dynamic value) {
    _storage[key] = value;
    debugPrint('Данные сохранены в памяти: $key');
  }

  /// Получить данные по ключу
  dynamic get(String key) {
    return _storage[key];
  }

  /// Удалить данные по ключу
  void remove(String key) {
    _storage.remove(key);
    debugPrint('Данные удалены из памяти: $key');
  }

  /// Проверить существование ключа
  bool exists(String key) {
    return _storage.containsKey(key);
  }

  /// Очистить все хранилище
  void clear() {
    _storage.clear();
    debugPrint('Хранилище очищено');
  }
}
