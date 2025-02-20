import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

// Перечисление для типов объектов
enum PlaceType {
  museum('Музеи'),
  monument('Памятники'),
  nature('Природа'),
  architecture('Архитектура');

  final String label;
  const PlaceType(this.label);
}

// Модель для культурных объектов
class CulturalPlace {
  final String name;
  final String description;
  final Point location;
  final PlaceType type;
  final String? imageUrl;

  CulturalPlace({
    required this.name,
    required this.description,
    required this.location,
    required this.type,
    this.imageUrl,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Координаты центра Чеченской Республики
  static const Point _chechenRepublicCenter =
      Point(latitude: 43.3169, longitude: 45.6981);

  MapWindow? _mapWindow;
  bool _showList = false; // Переключатель между картой и списком
  PlaceType? _selectedFilter; // Выбранный фильтр

  // Примерный список культурных объектов
  final List<CulturalPlace> _places = [
    CulturalPlace(
      name: 'Мечеть «Сердце Чечни»',
      description: 'Главная мечеть Чеченской Республики',
      location: const Point(latitude: 43.3179, longitude: 45.6817),
      type: PlaceType.architecture,
    ),
    CulturalPlace(
      name: 'Национальный музей',
      description: 'Главный исторический музей республики',
      location: const Point(latitude: 43.3249, longitude: 45.6922),
      type: PlaceType.museum,
    ),
    // Добавьте другие объекты по необходимости
  ];

  List<CulturalPlace> get _filteredPlaces {
    if (_selectedFilter == null) return _places;
    return _places.where((place) => place.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта'),
        actions: [
          // Кнопка переключения между картой и списком
          IconButton(
            icon: Icon(_showList ? Icons.map : Icons.list),
            onPressed: () {
              setState(() {
                _showList = !_showList;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Панель фильтров
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Все'),
                  selected: _selectedFilter == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = null;
                    });
                  },
                ),
                ...PlaceType.values.map((type) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Text(type.label),
                        selected: _selectedFilter == type,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = selected ? type : null;
                          });
                        },
                      ),
                    )),
              ],
            ),
          ),
          // Основной контент (карта или список)
          Expanded(
            child: _showList
                ? ListView.builder(
                    itemCount: _filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return ListTile(
                        title: Text(place.name),
                        subtitle: Text(place.description),
                        leading: Icon(_getIconForType(place.type)),
                        onTap: () {
                          setState(() {
                            _showList = false;
                          });
                          // Перемещаем карту к выбранному объекту
                          _mapWindow?.map.move(
                            CameraPosition(place.location,
                                zoom: 15, azimuth: 0, tilt: 0),
                          );
                        },
                      );
                    },
                  )
                : Stack(
                    children: [
                      YandexMap(
                        platformViewType: PlatformViewType.Hybrid,
                        onMapCreated: (MapWindow mapWindow) {
                          mapkit.onStart();
                          _mapWindow = mapWindow;
                          _mapWindow?.map.move(
                            CameraPosition(_chechenRepublicCenter,
                                zoom: 17, azimuth: 0, tilt: 0),
                          );
                        },
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () {
                            if (_mapWindow != null) {
                              _mapWindow!.map.move(
                                CameraPosition(_chechenRepublicCenter,
                                    zoom: 10, azimuth: 130, tilt: 30),
                              );
                            }
                          },
                          child: const Icon(Icons.center_focus_strong),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(PlaceType type) {
    switch (type) {
      case PlaceType.museum:
        return Icons.museum;
      case PlaceType.monument:
        return Icons.account_balance;
      case PlaceType.nature:
        return Icons.landscape;
      case PlaceType.architecture:
        return Icons.architecture;
    }
  }
}
