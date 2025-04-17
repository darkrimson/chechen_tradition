import 'package:chechen_tradition/features/map_and_places/models/culture_place.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

final List<CulturalPlace> mockPlaces = [
  CulturalPlace(
    name: 'Мечеть «Сердце Чечни»',
    description: 'Главная мечеть Чеченской Республики',
    location: const Point(latitude: 43.31780, longitude: 45.69400),
    type: PlaceType.architecture,
  ),
  CulturalPlace(
    name: 'Национальный музей',
    description: 'Главный исторический музей республики',
    location: const Point(latitude: 43.3243, longitude: 45.682351),
    type: PlaceType.museum,
  ),
];
