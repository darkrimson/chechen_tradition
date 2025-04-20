import 'package:cached_network_image/cached_network_image.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/places/provider/places_provider.dart';
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
    // Устанавливаем начальный фильтр в провайдере, если он передан
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialFilter != null) {
        Provider.of<PlacesProvider>(context, listen: false)
            .setFilter(widget.initialFilter);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Используем провайдер вместо репозитория
    final placesProvider = Provider.of<PlacesProvider>(context);

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
                    placesProvider.setFilter(null);
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
                          placesProvider.setFilter(selected ? type : null);
                        },
                        showCheckmark: false,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: placesProvider.getFilteredPlaces().length,
              itemBuilder: (context, index) {
                final place = placesProvider.getFilteredPlaces()[index];
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
                                child: CachedNetworkImage(
                                  imageUrl: place.imageUrl!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey.shade300,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
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
                                place.type.icon,
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
                                    color: getCategoryColor(place.type)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    place.type.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: getCategoryColor(place.type),
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
