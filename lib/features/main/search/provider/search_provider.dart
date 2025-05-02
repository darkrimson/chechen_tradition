// lib/providers/search_provider.dart
import 'package:chechen_tradition/features/education/models/education.dart';
import 'package:chechen_tradition/features/education/models/question.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/search_item.dart';

class SearchProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<CulturalPlace> _places = [];
  List<Tradition> _traditions = [];
  List<Education> _education = [];
  List<SearchItem> _results = [];
  bool _isLoading = false;
  String? _error;

  List<SearchItem> get results => _results;
  bool get isLoading => _isLoading;
  String? get error => _error;

  SearchProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final futures = await Future.wait([
        _supabase.from('places').select(),
        _supabase.from('traditions').select(),
        _supabase.from('education').select(),
      ]);

      final places = futures[0] as List<dynamic>;
      final traditions = futures[1] as List<dynamic>;
      final education = futures[2] as List<dynamic>;

      _places = places.map((p) => CulturalPlace.fromMap(p)).toList();
      _traditions = traditions.map((t) => Tradition.fromMap(t)).toList();
      _education = [];
      for (var edu in education) {
        final questionsResponse = await _supabase
            .from('question')
            .select()
            .eq('id', edu['id']); // Замени на правильное имя поля
        final questions = (questionsResponse as List<dynamic>)
            .map((q) => Question.fromMap(q))
            .toList();
        _education.add(Education.fromMap(edu, questions));
      }
    } catch (e) {
      _error = 'Ошибка загрузки данных: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    if (query.length < 4) {
      _results = [];
      _error = null;
      notifyListeners();
      return;
    }

    try {
      final queryLower = query.toLowerCase();
      _results = [
        ..._places
            .where((p) => p.name.toLowerCase().contains(queryLower))
            .map((p) => SearchItem.fromPlace(p)),
        ..._traditions
            .where((t) => t.name.toLowerCase().contains(queryLower))
            .map((t) => SearchItem.fromTradition(t)),
        ..._education
            .where((e) => e.title.toLowerCase().contains(queryLower))
            .map((e) => SearchItem.fromEducation(e)),
      ];

      _results.sort((a, b) => a.title.compareTo(b.title));
      _error = null;
    } catch (e) {
      _error = 'Ошибка поиска: $e';
      _results = [];
    }

    notifyListeners();
  }

  void clearData() {
    _results = [];
    _error = null;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await _loadData();
  }
}
