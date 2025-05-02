import 'package:chechen_tradition/app.dart';
import 'package:chechen_tradition/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ajdzbyooxgkpfcnlxnnq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFqZHpieW9veGdrcGZjbmx4bm5xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYwMzY1MjgsImV4cCI6MjA2MTYxMjUyOH0.qPO7cQZSG0WDK-xz5Njyp759-i_1eC-JXy7PdAkRxuQ',
  );

  runApp(
    // Оборачиваем приложение в AppProviders для доступа к провайдерам
    const AppProviders(
      child: MyApp(),
    ),
  );
}
