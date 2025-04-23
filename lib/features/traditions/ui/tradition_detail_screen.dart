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
    // Получаем провайдер традиций
    final traditionProvider = Provider.of<TraditionProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Заголовок с изображением
          SliverAppBar(
            expandedHeight: 240.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                tradition.title,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black54,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    tradition.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: SvgPicture.network(
                          tradition.category.networkSvg,
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade700,
                        ),
                      );
                    },
                  ),
                  // Затемнение для лучшей читаемости
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.7, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Метка категории
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(tradition.category)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.network(
                          tradition.category.networkSvg,
                          width: 16,
                          height: 16,
                          color: _getCategoryColor(tradition.category),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tradition.category.label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(tradition.category),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      tradition.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: tradition.isLiked ? Colors.red : null,
                    ),
                    onPressed: () async {
                      // Используем провайдер для переключения избранного
                      await traditionProvider.toggleFavorite(tradition.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tradition.isLiked
                                ? 'Добавлено в избранное'
                                : 'Удалено из избранного',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Описание
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Описание
                  Text(
                    tradition.description,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tradition.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Заголовок рекомендаций
                  const Text(
                    'Похожие традиции',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Похожие традиции
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
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
                    padding: const EdgeInsets.all(16),
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
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  similarTradition.imageUrl,
                                  height: 120,
                                  width: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: Colors.grey.shade300,
                                      child: Center(
                                        child: Icon(
                                          Icons.ice_skating,
                                          // similarTradition.category.iconPath,
                                          size: 40,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                similarTradition.title,
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
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Пространство внизу страницы
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
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
