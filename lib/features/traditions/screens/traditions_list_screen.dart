import 'package:flutter/material.dart';
import 'package:chechen_tradition/data/traditions/mock_traditions.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:chechen_tradition/features/traditions/screens/tradition_detail_screen.dart';

class TraditionsListScreen extends StatefulWidget {
  final TraditionCategory? initialFilter;

  const TraditionsListScreen({Key? key, this.initialFilter}) : super(key: key);

  @override
  State<TraditionsListScreen> createState() => _TraditionsListScreenState();
}

class _TraditionsListScreenState extends State<TraditionsListScreen> {
  TraditionCategory? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTraditions = _getFilteredTraditions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Традиции и обычаи'),
      ),
      body: Column(
        children: [
          // Категории фильтров
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
                        Icons.all_inclusive,
                        size: 30,
                        color: _selectedFilter == null
                            ? Colors.black
                            : Colors.black,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Все',
                        style: TextStyle(
                          color: Colors.black,
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
                ...TraditionCategory.values.map((category) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: FilterChip(
                        label: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              category.iconPath,
                              size: 30,
                              color: _selectedFilter == category
                                  ? Colors.black
                                  : Colors.black,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.label,
                              style: TextStyle(
                                color: _selectedFilter == category
                                    ? Colors.black
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        selected: _selectedFilter == category,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = selected ? category : null;
                          });
                        },
                        showCheckmark: false,
                      ),
                    )),
              ],
            ),
          ),
          // Список традиций
          Expanded(
            child: filteredTraditions.isEmpty
                ? const Center(
                    child: Text('Нет традиций в выбранной категории'),
                  )
                : ListView.builder(
                    itemCount: filteredTraditions.length,
                    itemBuilder: (context, index) {
                      final tradition = filteredTraditions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    tradition.imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey.shade300,
                                        child: Icon(
                                          tradition.category.iconPath,
                                          size: 40,
                                          color: Colors.grey.shade700,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tradition.title,
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
                                          color: _getCategoryColor(
                                                  tradition.category)
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          tradition.category.label,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _getCategoryColor(
                                                tradition.category),
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

  List<Tradition> _getFilteredTraditions() {
    if (_selectedFilter == null) {
      return mockTraditions;
    }
    return mockTraditions
        .where((tradition) => tradition.category == _selectedFilter)
        .toList();
  }

  Color _getCategoryColor(TraditionCategory category) {
    switch (category) {
      case TraditionCategory.clothing:
        return Colors.blue;
      case TraditionCategory.cuisine:
        return Colors.orange;
      case TraditionCategory.crafts:
        return Colors.amber.shade800;
      case TraditionCategory.holidays:
        return Colors.green;
    }
  }
}
