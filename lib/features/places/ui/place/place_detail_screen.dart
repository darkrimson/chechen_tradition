import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/places/provider/places_provider.dart';
import '../map/map_screen.dart';

class PlaceDetailScreen extends StatefulWidget {
  final CulturalPlace place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Получаем фактическое количество изображений
    int imagesCount = widget.place.images?.length ?? 0;

    // Получаем провайдер для работы с избранным
    final placesProvider = Provider.of<PlacesProvider>(context);
    final isFavorite = placesProvider.isFavorite(widget.place.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.name),
        actions: [
          // Кнопка открытия карты
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: 'Показать на карте',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(place: widget.place),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'place_image_${widget.place.name}',
              child: CachedNetworkImage(
                imageUrl: widget.place.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade300,
                  height: 250,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: getCategoryColor(widget.place.type)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.network(
                              widget.place.type.networkSvg,
                              width: 18,
                              height: 18,
                              color: getCategoryColor(widget.place.type),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.place.type.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: getCategoryColor(widget.place.type),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        tooltip: isFavorite
                            ? 'Удалить из избранного'
                            : 'Добавить в избранное',
                        onPressed: () {
                          placesProvider.toggleFavorite(widget.place.name);

                          // Показываем уведомление о действии
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isFavorite
                                    ? 'Удалено из избранного'
                                    : 'Добавлено в избранное',
                              ),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'OK',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.place.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Описание',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.place.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (imagesCount > 0) ...[
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Фотогалерея',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${_currentImageIndex + 1}/${imagesCount}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200,
                        viewportFraction: 0.8,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: widget.place.images?.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    _showFullScreenImage(context, imageUrl,
                                        widget.place.images!);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.black.withOpacity(0.2),
                                      //     spreadRadius: 1,
                                      //     blurRadius: 5,
                                      //     offset: const Offset(0, 3),
                                      //   ),
                                      // ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                              color: Colors.grey.shade300,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.error,
                                                        color: Colors.grey),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      'Ошибка загрузки',
                                                      style: TextStyle(
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: const Icon(
                                              Icons.zoom_in,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList() ??
                          [],
                    ),
                    if (imagesCount > 1) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            widget.place.images!.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade400,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(place: widget.place),
                        ),
                      );
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Показать на карте'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(
      BuildContext context, String imageUrl, List<String> allImages) {
    int initialIndex = allImages.indexOf(imageUrl);
    int currentFullScreenIndex = initialIndex;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StatefulBuilder(builder: (context, setState) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                'Фото ${currentFullScreenIndex + 1}/${allImages.length}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height,
                    viewportFraction: 1.0,
                    initialPage: initialIndex,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentFullScreenIndex = index;
                      });
                    },
                  ),
                  items: allImages.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Icon(Icons.error,
                                    color: Colors.white, size: 50),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: allImages.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentFullScreenIndex == entry.key
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
