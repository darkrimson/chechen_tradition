import 'package:chechen_tradition/data/places/places_repository.dart';
import 'package:chechen_tradition/models/culture_place.dart';
import 'package:flutter/material.dart';
import 'map_screen.dart';

class PlacesListScreen extends StatefulWidget {
  const PlacesListScreen({super.key});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  PlaceType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = PlacesRepository().filteredPlaces;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список мест'),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                FilterChip(
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.all_out,
                        size: 30,
                        color: _selectedFilter == null
                            ? Colors.black
                            : Colors.black,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Все',
                        style: TextStyle(
                          color: _selectedFilter == null
                              ? Colors.black
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  selected: _selectedFilter == null,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = null;
                    });
                  },
                  showCheckmark: false,
                ),
                ...PlaceType.values.map((type) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              type.icon,
                              size: 30,
                              color: _selectedFilter == type
                                  ? Colors.black
                                  : Colors.black,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              type.label,
                              style: TextStyle(
                                color: _selectedFilter == type
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        selected: _selectedFilter == type,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = selected ? type : null;
                          });
                        },
                        showCheckmark: false,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces(_selectedFilter).length,
              itemBuilder: (context, index) {
                final place = filteredPlaces(_selectedFilter)[index];
                return ListTile(
                  title: Text(place.name),
                  subtitle: Text(place.description),
                  leading: Icon(getIconForType(place.type)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(place: place),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
