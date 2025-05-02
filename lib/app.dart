import 'package:chechen_tradition/features/education/ui/education/education_list_screen.dart';
import 'package:chechen_tradition/features/main/home/ui/home_screen.dart';
import 'package:chechen_tradition/features/places/ui/place/places_list_screen.dart';
import 'package:chechen_tradition/features/traditions/ui/traditions_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Устанавливаем цвет шторки уведомлений
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF8B0000), // Бордовый цвет для шторки
        statusBarIconBrightness: Brightness.light, // Белые иконки в шторке
        systemNavigationBarColor: Colors.white, // Цвет панели навигации внизу
        systemNavigationBarIconBrightness:
            Brightness.dark, // Темные иконки в панели навигации
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Культурное наследие',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000),
          primary: const Color(0xFF8B0000), // бордовый цвет
          secondary: const Color(0xFF006400), // зеленый цвет
          onSecondary: Colors.white,
          background: Colors.white,
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8B0000),
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xFF8B0000),
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.light,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const PlacesListScreen(),
    const TraditionsListScreen(),
    const EducationScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.grey,
        useLegacyColorScheme: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Места',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration),
            label: 'Традиции',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Обучение',
          ),
        ],
      ),
    );
  }
}
