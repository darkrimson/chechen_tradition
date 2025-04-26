import 'package:cached_network_image/cached_network_image.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/places/provider/places_provider.dart';
import 'package:chechen_tradition/features/places/ui/map/places_map_widget.dart';
import 'package:chechen_tradition/common/ui/favorites_screen.dart';
import 'place_detail_screen.dart';

class PlacesListScreen extends StatefulWidget {
  final PlaceType? initialFilter;

  const PlacesListScreen({super.key, this.initialFilter});

  @override
  State<PlacesListScreen> createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  PlaceType? _selectedFilter;
  bool _showMapView = false; // По умолчанию показываем список

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
        actions: [
          // Кнопка для перехода на экран избранного
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Избранное',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FavoritesScreen(type: FavoriteType.places),
                ),
              );
            },
          ),
          // Кнопка переключения между картой и списком
          IconButton(
            icon: Icon(_showMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _showMapView = !_showMapView;
              });
            },
            tooltip: _showMapView ? 'Показать список' : 'Показать карту',
          ),
        ],
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
                      // Icon(
                      //   Icons.all_out,
                      //   size: 30,
                      //   color: _selectedFilter == null
                      //       ? Colors.black
                      //       : Colors.black,
                      // ),
                      SvgPicture.network(
                        'https://www.svgrepo.com/show/446706/justify-all.svg',
                        width: 30,
                        height: 30,
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
                            SvgPicture.network(
                              type.networkSvg,
                              width: 30,
                              height: 30,
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
            child: _showMapView
                ? PlacesMapWidget(
                    places: placesProvider.places,
                    filter: _selectedFilter,
                  )
                : ListView.builder(
                    itemCount: placesProvider.getFilteredPlaces().length,
                    itemBuilder: (context, index) {
                      final place = placesProvider.getFilteredPlaces()[index];
                      // Проверяем, находится ли место в избранном
                      final isFavorite = placesProvider.isFavorite(place.name);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PlaceDetailScreen(place: place),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (place.imageUrl != null)
                                  Hero(
                                    tag: 'place_image_${place.name}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: place.imageUrl!,
                                        width: 100,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
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
                                    child: SvgPicture.network(
                                      place.type.networkSvg,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const SizedBox(height: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: getCategoryColor(place.type)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                      // Отображаем индикатор избранного, если место в избранном
                                      if (isFavorite) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'В избранном',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
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
