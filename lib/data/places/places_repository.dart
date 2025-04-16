import 'package:chechen_tradition/data/places/mock_places.dart';
import 'package:chechen_tradition/models/culture_place.dart';

class PlacesRepository {
  final List<CulturalPlace> _places = mockPlaces;

  List<CulturalPlace> filteredPlaces(PlaceType? selectedFilter) {
    if (selectedFilter == null) return _places;
    return _places.where((place) => place.type == selectedFilter).toList();
  }
}
