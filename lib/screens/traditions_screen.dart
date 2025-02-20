import 'package:chechen_tradition/screens/tradition_detail_screen.dart';
import 'package:flutter/material.dart';
import '../models/tradition.dart';

class TraditionsScreen extends StatefulWidget {
  const TraditionsScreen({Key? key}) : super(key: key);

  @override
  State<TraditionsScreen> createState() => _TraditionsScreenState();
}

class _TraditionsScreenState extends State<TraditionsScreen> {
  TraditionCategory? selectedCategory;

  // Временные данные для примера
  final List<Tradition> traditions = [
    Tradition(
      id: '1',
      title: 'Чеченский национальный костюм',
      description: 'История и особенности традиционной чеченской одежды',
      content: '''
Чеченский национальный костюм является важной частью культурного наследия народа. 
Мужской костюм включает черкеску, бешмет и папаху. Женский костюм состоит из длинного платья, 
украшенного национальным орнаментом, и головного убора.

Каждый элемент костюма имеет свое символическое значение и отражает статус его владельца.
      ''',
      imageUrl: 'assets/images/costume.jpg',
      category: TraditionCategory.clothing,
    ),
    // Добавьте другие традиции
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Традиции',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Красивый заголовок с градиентом
          // Категории
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: TraditionCategory.values.length,
                itemBuilder: (context, index) {
                  final category = TraditionCategory.values[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CategoryCard(
                      category: category,
                      isSelected: selectedCategory == category,
                      onTap: () {
                        setState(() {
                          selectedCategory =
                              selectedCategory == category ? null : category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // Список статей
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tradition = traditions[index];
                return TraditionCard(
                  tradition: tradition,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TraditionDetailScreen(tradition: tradition),
                      ),
                    );
                  },
                );
              },
              childCount: traditions.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final TraditionCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B0000) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 32,
              color: isSelected ? Colors.white : const Color(0xFF8B0000),
            ),
            const SizedBox(height: 8),
            Text(
              category.label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(TraditionCategory category) {
    switch (category) {
      case TraditionCategory.clothing:
        return Icons.checkroom;
      case TraditionCategory.cuisine:
        return Icons.restaurant;
      case TraditionCategory.crafts:
        return Icons.construction;
      case TraditionCategory.holidays:
        return Icons.celebration;
    }
  }
}

class TraditionCard extends StatelessWidget {
  final Tradition tradition;
  final VoidCallback onTap;

  const TraditionCard({
    Key? key,
    required this.tradition,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'tradition-${tradition.id}',
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(
                  tradition.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            tradition.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            tradition.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: const Color(0xFF8B0000),
                          ),
                          onPressed: () {
                            // Обработка лайка
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tradition.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
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
}
