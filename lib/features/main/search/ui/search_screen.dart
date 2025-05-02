// lib/features/search/ui/search_screen.dart
import 'package:chechen_tradition/features/education/models/education.dart';
import 'package:chechen_tradition/features/education/ui/education/education_detail_screen.dart';
import 'package:chechen_tradition/features/main/search/models/search_item.dart';
import 'package:chechen_tradition/features/main/search/provider/search_provider.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:chechen_tradition/features/places/ui/place/place_detail_screen.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:chechen_tradition/features/traditions/ui/tradition_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    context.read<SearchProvider>().clearData();
    super.dispose();
  }

  @override
  void initState() {
    context.read<SearchProvider>().refreshData();
    super.initState();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchProvider>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Поиск...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearchChanged,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                context.read<SearchProvider>().clearData();
              },
            ),
        ],
      ),
      body: Consumer<SearchProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (_searchController.text.length < 4) {
            return const Center(child: Text('Введите минимум 4 символа'));
          }

          if (provider.results.isEmpty) {
            return const Center(child: Text('Ничего не найдено'));
          }

          return ListView.builder(
            itemCount: provider.results.length,
            itemBuilder: (context, index) {
              final item = provider.results[index];
              return _SearchResultItem(item: item);
            },
          );
        },
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final SearchItem item;

  const _SearchResultItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(context, item),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, size: 40),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100,
                    height: 120,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
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
                        color: getCategoryColorForSearch(item.type)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.type.label,
                        style: TextStyle(
                          fontSize: 12,
                          color: getCategoryColorForSearch(item.type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildTypeIcon(SearchItemType type) {
    IconData icon;
    Color color;

    switch (type) {
      case SearchItemType.place:
        icon = Icons.place;
        color = Colors.blue;
        break;
      case SearchItemType.tradition:
        icon = Icons.history_edu;
        color = Colors.orange;
        break;
      case SearchItemType.education:
        icon = Icons.school;
        color = Colors.green;
        break;
    }

    return CircleAvatar(
      radius: 15,
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, size: 18, color: color),
    );
  }

  void _navigateToDetail(BuildContext context, SearchItem item) {
    Widget screen;
    switch (item.type) {
      case SearchItemType.place:
        screen = PlaceDetailScreen(place: item.originalItem as CulturalPlace);
        break;
      case SearchItemType.tradition:
        screen =
            TraditionDetailScreen(tradition: item.originalItem as Tradition);
        break;
      case SearchItemType.education:
        screen = EducationDetailScreen(content: item.originalItem as Education);
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
