import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:chechen_tradition/features/places/ui/place/place_detail_screen.dart';

class PlacesMapWidget extends StatelessWidget {
  final List<CulturalPlace> places;
  final PlaceType? filter;

  const PlacesMapWidget({
    super.key,
    required this.places,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    // Фильтруем места, если задан фильтр
    final filteredPlaces = filter == null
        ? places
        : places.where((place) => place.type == filter).toList();

    // Находим центр карты (среднее значение координат всех мест)
    LatLng center;
    if (filteredPlaces.isNotEmpty) {
      double avgLat = 0;
      double avgLng = 0;
      for (var place in filteredPlaces) {
        avgLat += place.latLng.latitude;
        avgLng += place.latLng.longitude;
      }
      center = LatLng(
          avgLat / filteredPlaces.length, avgLng / filteredPlaces.length);
    } else {
      // Если нет мест, устанавливаем центр на Грозный
      center = const LatLng(43.31780, 45.69400);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 10.0,
        interactionOptions: const InteractionOptions(
          enableMultiFingerGestureRace: true,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.chechen_tradition.app',
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: filteredPlaces.map((place) {
            return Marker(
              point: place.latLng,
              width: 40.0,
              height: 40.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(place: place),
                    ),
                  );
                },
                child: _buildMarker(place),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMarker(CulturalPlace place) {
    return Stack(
      children: [
        // Фон маркера
        Container(
          decoration: BoxDecoration(
            color: getCategoryColor(place.type),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        // Иконка категории места
        Center(
          child: SvgPicture.network(
            place.type.networkSvg,
            width: 20,
            height: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
