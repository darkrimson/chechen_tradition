import 'package:chechen_tradition/data/places/places_repository.dart';
import 'package:chechen_tradition/features/map_and_places/models/culture_place.dart';
import 'package:flutter/material.dart';
import '../map/map_screen.dart';
import 'place_detail_screen.dart';

class PlacesListScreen extends StatefulWidget {
  final PlaceType? initialFilter;

  const PlacesListScreen({super.key, this.initialFilter});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  PlaceType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

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
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaceDetailScreen(place: place),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          if (place.imageUrl != null)
                            Hero(
                              tag: 'place_image_${place.name}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  place.imageUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: Icon(
                                        getIconForType(place.type),
                                        size: 40,
                                        color: Colors.grey.shade700,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          else
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                getIconForType(place.type),
                                size: 40,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  place.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    place.type.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
