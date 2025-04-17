import 'package:chechen_tradition/features/map_and_places/models/culture_place.dart';
import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
// ignore: implementation_imports
import 'package:yandex_maps_mapkit/src/bindings/image/image_provider.dart'
    // ignore: library_prefixes
    as yandexImage;
import 'package:yandex_maps_mapkit/yandex_map.dart';

class MapScreen extends StatefulWidget {
  final CulturalPlace place;

  const MapScreen({super.key, required this.place});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapWindow? _mapWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
      ),
      body: Stack(
        children: [
          YandexMap(
            platformViewType: PlatformViewType.Hybrid,
            onMapCreated: (MapWindow mapWindow) {
              final imageProvider =
                  yandexImage.ImageProvider.fromImageProvider(const AssetImage(
                "images/mark.png",
              ));
              mapkit.onStart();
              _mapWindow = mapWindow;
              mapWindow.map.mapObjects.addPlacemark()
                ..geometry = widget.place.location
                ..setIcon(imageProvider)
                ..setIconStyle(IconStyle(
                    scale: 0.4, flat: true, rotationType: RotationType.Rotate));
              _mapWindow?.map.move(
                CameraPosition(widget.place.location,
                    zoom: 17.5, azimuth: 0, tilt: 0),
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _mapWindow?.map.move(
                  CameraPosition(widget.place.location,
                      zoom: 17.5, azimuth: 0, tilt: 0),
                );
              },
              child: const Icon(Icons.center_focus_strong),
            ),
          ),
        ],
      ),
    );
  }
}
