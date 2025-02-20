import 'package:chechen_tradition/screens/home_screen.dart';
import 'package:chechen_tradition/screens/map_screen.dart';
import 'package:chechen_tradition/screens/traditions_screen.dart';
import 'package:chechen_tradition/screens/education_screen.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init.initMapkit(apiKey: '511120c2-c3dd-4d7a-8633-8ab0991a24f9');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Культурное наследие',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          onPrimary: const Color(0xFF8B0000), // бордовый цвет
          secondary: const Color(0xFF006400),
          seedColor: Colors.black, // зеленый цвет
        ),
        useMaterial3: true,
      ),
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
    const MapScreen(),
    const TraditionsScreen(),
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
            label: 'Карта',
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
