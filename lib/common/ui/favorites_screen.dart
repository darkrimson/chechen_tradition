import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart'
    as places;
import 'package:chechen_tradition/features/places/provider/places_provider.dart';
import 'package:chechen_tradition/features/places/ui/place/place_detail_screen.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart'
    as traditions;
import 'package:chechen_tradition/features/traditions/provider/tradition_provider.dart';
import 'package:chechen_tradition/features/traditions/ui/tradition_detail_screen.dart';

enum FavoriteType {
  places,
  traditions,
}

class FavoritesScreen extends StatelessWidget {
  final FavoriteType type;

  const FavoritesScreen({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type == FavoriteType.places
            ? 'Избранные места'
            : 'Избранные традиции'),
      ),
      body: type == FavoriteType.places
          ? _buildPlacesList(context)
          : _buildTraditionsList(context),
    );
  }

  Widget _buildPlacesList(BuildContext context) {
    return Consumer<PlacesProvider>(
      builder: (context, provider, child) {
        final favoritePlaces = provider.getFavoritePlaces();

        if (favoritePlaces.isEmpty) {
          return _buildEmptyState('У вас пока нет избранных мест',
              'Добавляйте интересные места в избранное,\nчтобы быстро находить их позже');
        }

        return ListView.builder(
          itemCount: favoritePlaces.length,
          itemBuilder: (context, index) {
            final place = favoritePlaces[index];
            return _buildPlaceCard(context, place, provider);
          },
        );
      },
    );
  }

  Widget _buildTraditionsList(BuildContext context) {
    return Consumer<TraditionProvider>(
      builder: (context, provider, child) {
        final favoriteTraditions = provider.getFavoriteTraditions();

        if (favoriteTraditions.isEmpty) {
          return _buildEmptyState('У вас пока нет избранных традиций',
              'Добавляйте интересные традиции в избранное,\nчтобы быстро находить их позже');
        }

        return ListView.builder(
          itemCount: favoriteTraditions.length,
          itemBuilder: (context, index) {
            final tradition = favoriteTraditions[index];
            return _buildTraditionCard(context, tradition, provider);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, places.CulturalPlace place,
      PlacesProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: place.imageUrl!,
                    width: 100,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: CircularProgressIndicator(),
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
                        color: places
                            .getCategoryColor(place.type)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        place.type.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: places.getCategoryColor(place.type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Отображаем индикатор избранного, если место в избранном

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
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTraditionCard(BuildContext context,
      traditions.Tradition tradition, TraditionProvider provider) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TraditionDetailScreen(
                tradition: tradition,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: tradition.imageUrl,
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade300,
                      child: SvgPicture.network(
                        tradition.category.networkSvg,
                        width: 40,
                        height: 40,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tradition.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tradition.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: traditions
                            .getCategoryColor(tradition.category)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tradition.category.label,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              traditions.getCategoryColor(tradition.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
