import 'package:flutter/material.dart';
import '../models/search_result.dart';
import '../services/search_service.dart';
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
  final SearchService _searchService = SearchService();

  List<SearchResult> _searchResults = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _showHistory = true;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final history = await _searchService.getSearchHistory();

      setState(() {
        _searchHistory = history;
        _isLoading = false;
      });
    } catch (e) {
      // В случае ошибки показываем пустую историю
      setState(() {
        _searchHistory = [];
        _isLoading = false;
      });
      debugPrint('Ошибка при загрузке истории поиска: $e');
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _showHistory = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showHistory = false;
    });

    try {
      final results = await _searchService.search(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoading = false;
        });
      }

      try {
        await _searchService.saveToHistory(query);

        // Обновляем историю после сохранения
        if (mounted) {
          _loadSearchHistory();
        }
      } catch (historyError) {
        debugPrint('Ошибка при сохранении истории: $historyError');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка поиска: $e')),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _showHistory = true;
    });
  }

  Future<void> _clearHistory() async {
    try {
      await _searchService.clearSearchHistory();

      setState(() {
        _searchHistory = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('История поиска очищена')),
      );
    } catch (e) {
      debugPrint('Ошибка при очистке истории: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось очистить историю поиска')),
      );
    }
  }

  void _navigateToDetail(BuildContext context, SearchResult result) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: _clearSearch,
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
                  setState(() {
                    _searchResults = [];
                    _showHistory = true;
                  });
                }
              },
              onSubmitted: _performSearch,
              textInputAction: TextInputAction.search,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _showHistory
                    ? _buildSearchHistory()
                    : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory() {
    if (_searchHistory.isEmpty) {
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
                onPressed: _clearHistory,
                child: const Text('Очистить'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchHistory.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(_searchHistory[index]),
                onTap: () {
                  _searchController.text = _searchHistory[index];
                  _performSearch(_searchHistory[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text('Ничего не найдено'),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: InkWell(
            onTap: () => _navigateToDetail(context, result),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:
                        result.imageUrl != null && result.imageUrl!.isNotEmpty
                            ? (result.imageUrl!.startsWith('http')
                                ? Image.network(
                                    result.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholderImage(result);
                                    },
                                  )
                                : Image.asset(
                                    result.imageUrl!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
