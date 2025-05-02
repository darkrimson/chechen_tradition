import 'package:chechen_tradition/features/main/search/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Импорт всех провайдеров
import 'package:chechen_tradition/features/traditions/provider/tradition_provider.dart';
import 'package:chechen_tradition/features/education/provider/education_provider.dart';
import 'package:chechen_tradition/features/places/provider/places_provider.dart';
import 'package:chechen_tradition/features/main/settings/provider/settings_provider.dart';

/// Класс для организации всех провайдеров приложения
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Используем MultiProvider для регистрации всех провайдеров
    return MultiProvider(
      providers: [
        // Провайдер для традиций
        ChangeNotifierProvider(
          create: (_) => TraditionProvider(),
        ),

        // Провайдер для образовательного контента
        ChangeNotifierProvider(
          create: (_) => EducationProvider(),
        ),

        // Провайдер для мест и карты
        ChangeNotifierProvider(
          create: (_) => PlacesProvider(),
        ),

        // Провайдер для поиска
        ChangeNotifierProvider(
          create: (_) => SearchProvider(),
        ),

        // Провайдер для настроек
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: child,
    );
  }
}
