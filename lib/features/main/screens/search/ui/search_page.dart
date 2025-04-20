import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../models/search_result.dart';
import '../services/search_provider.dart';
import 'package:chechen_tradition/features/map_and_places/screens/place/place_detail_screen.dart';
import 'package:chechen_tradition/features/traditions/screens/tradition_detail_screen.dart';
// import 'package:chechen_tradition/features/education/screens/education_detail_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  // Таймер для дебаунса поиска
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
  }

  // При нажатии на результат: сохраняем запрос в историю и переходим к детальному просмотру
  void _navigateToDetail(BuildContext context, SearchResult result) {
    // Сначала сохраняем текущий запрос в историю
    if (_searchController.text.isNotEmpty) {
      Provider.of<SearchProvider>(context, listen: false)
          .saveCurrentQueryToHistory();
    }

    // Затем переходим к детальному просмотру
    switch (result.type) {
      case SearchResultType.place:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: result.originalItem),
          ),
        );
        break;
      case SearchResultType.tradition:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TraditionDetailScreen(tradition: result.originalItem),
          ),
        );
        break;
      case SearchResultType.education:
        // Временное решение - показать SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Переход к материалу: ${result.title}')),
        );
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Функция для дебаунса поиска при вводе текста
  void _onSearchChanged(String query, SearchProvider provider) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Задержка в 300 мс перед выполнением поиска
    // чтобы не делать запрос при каждом нажатии клавиши
    _debounce = Timer(const Duration(milliseconds: 300), () {
      provider.searchOnType(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск мест, событий, статей...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          searchProvider.clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  searchProvider.clearSearch();
                } else {
                  // Выполняем поиск при вводе текста
                  _onSearchChanged(value, searchProvider);
                }
              },
              onSubmitted: (value) {
                // При нажатии Enter выполняем полноценный поиск
                if (value.isNotEmpty) {
                  searchProvider.performSearch(value);
                }
              },
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (_searchController.text.isEmpty) {
                  // Проверяем именно текст поля ввода, а не currentQuery
                  return _buildSearchHistory(provider);
                } else {
                  return _buildSearchResults(provider);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory(SearchProvider provider) {
    if (provider.searchHistory.isEmpty) {
      return const Center(
        child: Text('История поиска пуста'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'История поиска',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  provider.clearHistory();
                },
                child: const Text('Очистить'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(provider.searchHistory[index]),
                onTap: () {
                  _searchController.text = provider.searchHistory[index];
                  provider.searchFromHistory(provider.searchHistory[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(SearchProvider provider) {
    if (provider.searchResults.isEmpty) {
      return const Center(
        child: Text('Ничего не найдено'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок с текущим поисковым запросом
        if (provider.currentQuery.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Результаты поиска по запросу "${provider.currentQuery}"',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.searchResults.length,
            itemBuilder: (context, index) {
              final result = provider.searchResults[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: InkWell(
                  onTap: () => _navigateToDetail(context, result),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: result.imageUrl != null &&
                                  result.imageUrl!.isNotEmpty
                              ? (result.imageUrl!.startsWith('http')
                                  ? Image.network(
                                      result.imageUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildPlaceholderImage(result);
                                      },
                                    )
                                  : Image.asset(
                                      result.imageUrl!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return _buildPlaceholderImage(result);
                                      },
                                    ))
                              : _buildPlaceholderImage(result),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                result.description,
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
                                  color: _getColorForType(result.type),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  result.type.displayName,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
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
    );
  }

  Widget _buildPlaceholderImage(SearchResult result) {
    IconData iconData;
    switch (result.type) {
      case SearchResultType.place:
        iconData = Icons.place;
        break;
      case SearchResultType.tradition:
        iconData = Icons.history_edu;
        break;
      case SearchResultType.education:
        iconData = Icons.school;
        break;
    }

    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade300,
      child: Icon(iconData, color: Colors.grey.shade700),
    );
  }

  Color _getColorForType(SearchResultType type) {
    switch (type) {
      case SearchResultType.place:
        return Colors.blue;
      case SearchResultType.tradition:
        return Colors.orange;
      case SearchResultType.education:
        return Colors.green;
    }
  }
}
