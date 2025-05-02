import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:chechen_tradition/features/traditions/ui/tradition_detail_screen.dart';
import 'package:chechen_tradition/features/traditions/provider/tradition_provider.dart';
import 'package:chechen_tradition/common/ui/favorites_screen.dart';

class TraditionsListScreen extends StatelessWidget {
  final TraditionCategory? initialFilter;

  const TraditionsListScreen({super.key, this.initialFilter});

  @override
  Widget build(BuildContext context) {
    // Получаем провайдер традиций
    final traditionProvider = Provider.of<TraditionProvider>(context);

    // Устанавливаем начальный фильтр, если он передан
    if (initialFilter != null &&
        traditionProvider.selectedFilter != initialFilter) {
      // Выполняем асинхронно, чтобы не вызывать обновление во время сборки
      Future.microtask(() => traditionProvider.setFilter(initialFilter));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Традиции и обычаи'),
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
                      const FavoritesScreen(type: FavoriteType.traditions),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Категории фильтров
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Consumer<TraditionProvider>(
                builder: (context, provider, child) {
              return Row(
                children: [
                  FilterChip(
                    label: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.network(
                          'https://www.svgrepo.com/show/446706/justify-all.svg',
                          width: 30,
                          height: 30,
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
                    selected: provider.selectedFilter == null,
                    onSelected: (selected) {
                      provider.setFilter(null);
                    },
                    showCheckmark: false,
                  ),
                  ...TraditionCategory.values.map((category) => Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          label: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.network(
                                category.networkSvg,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                category.label,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          selected: provider.selectedFilter == category,
                          onSelected: (selected) {
                            provider.setFilter(selected ? category : null);
                          },
                          showCheckmark: false,
                        ),
                      )),
                ],
              );
            }),
          ),

          // Список традиций
          Expanded(
            child: Consumer<TraditionProvider>(
              builder: (context, provider, child) {
                final filteredTraditions = provider.getFilteredTraditions();

                if (filteredTraditions.isEmpty) {
                  return const Center(
                    child: Text('Нет традиций в выбранной категории'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredTraditions.length,
                  itemBuilder: (context, index) {
                    final tradition = filteredTraditions[index];
                    final isFavorite = provider.isFavorite(tradition.id);

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
                                        color:
                                            getCategoryColor(tradition.category)
                                                .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        tradition.category.label,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: getCategoryColor(
                                              tradition.category),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
