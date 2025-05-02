import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:chechen_tradition/features/traditions/provider/tradition_provider.dart';

class TraditionDetailScreen extends StatelessWidget {
  final Tradition tradition;

  const TraditionDetailScreen({super.key, required this.tradition});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tradition.name),
      ),
      body: Consumer<TraditionProvider>(
        builder: (context, provider, _) {
          final isFavorite = provider.isFavorite(tradition.id);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Главное изображение
                CachedNetworkImage(
                  imageUrl: tradition.imageUrl,
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
                  errorWidget: (context, url, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey.shade300,
                      child: SvgPicture.network(
                        tradition.category.networkSvg,
                        width: 100,
                        height: 100,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
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
                              color: getCategoryColor(tradition.category)
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.network(
                                  tradition.category.networkSvg,
                                  width: 18,
                                  height: 18,
                                  color: getCategoryColor(tradition.category),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  tradition.category.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: getCategoryColor(
                                            tradition.category),
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                            ),
                            tooltip: isFavorite
                                ? 'Удалить из избранного'
                                : 'Добавить в избранное',
                            onPressed: () async {
                              await provider.toggleFavorite(tradition.id);
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
                        tradition.name,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      Text(
                        tradition.description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tradition.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                            ),
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        'Похожие традиции',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: Consumer<TraditionProvider>(
                    builder: (context, provider, child) {
                      // Получаем другие традиции той же категории
                      final similarTraditions = provider.traditions
                          .where((t) =>
                              t.category == tradition.category &&
                              t.id != tradition.id)
                          .take(3)
                          .toList();

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: similarTraditions.length,
                        itemBuilder: (context, index) {
                          final similarTradition = similarTraditions[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TraditionDetailScreen(
                                    tradition: similarTradition,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 160,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: similarTradition.imageUrl,
                                      height: 120,
                                      width: 160,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.shade300,
                                        height: 120,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 120,
                                          color: Colors.grey.shade300,
                                          child: SvgPicture.network(
                                            similarTradition
                                                .category.networkSvg,
                                            width: 40,
                                            height: 40,
                                            color: Colors.grey.shade700,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    similarTradition.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    similarTradition.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Показываем статус избранного
                                  if (isFavorite) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'В избранном',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
