import 'package:chechen_tradition/app.dart';
import 'package:chechen_tradition/app_providers.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Оборачиваем приложение в AppProviders для доступа к провайдерам
    const AppProviders(
      child: MyApp(),
    ),
  );
}
