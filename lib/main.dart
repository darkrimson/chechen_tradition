import 'package:chechen_tradition/app.dart';
import 'package:chechen_tradition/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(apiKey: '511120c2-c3dd-4d7a-8633-8ab0991a24f9');

  runApp(
    // Оборачиваем приложение в AppProviders для доступа к провайдерам
    const AppProviders(
      child: MyApp(),
    ),
  );
}
