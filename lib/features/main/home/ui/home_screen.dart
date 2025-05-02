import 'package:cached_network_image/cached_network_image.dart';
import 'package:chechen_tradition/data/event_items/mock_event_items.dart';
import 'package:chechen_tradition/features/main/home/models/event_item.dart';
import 'package:chechen_tradition/features/main/search/ui/search_screen.dart';
import 'package:chechen_tradition/features/main/settings/ui/settings_screen.dart';
import 'package:chechen_tradition/features/places/ui/place/places_list_screen.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:chechen_tradition/features/traditions/ui/traditions_list_screen.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Текущий индекс карусели
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Верхняя панель с поиском и настройками
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Навигация на экран поиска
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        child: AbsorbPointer(
                          child: SearchBar(
                            hintText: 'Поиск мест, событий, статей...',
                            leading: const Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          // Навигация на экран настроек
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Карусель событий
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Предстоящие события',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      itemCount: events.length,
                      controller: PageController(viewportFraction: 0.9),
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildEventCard(events[index]);
                      },
                    ),
                  ),
                  // Индикаторы страниц
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      events.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCarouselIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Заголовок категорий
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text(
                  'Категории',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),

            // Категории
            SliverPadding(
              padding: const EdgeInsets.all(14.0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final categories = [
                      'Исторические памятники',
                      'Природа',
                      'Ремесла',
                      'События'
                    ];
                    final icons = [
                      Icons.account_balance,
                      Icons.landscape,
                      Icons.brush,
                      Icons.event
                    ];

                    // Цвета для категорий
                    final colors = [
                      Colors.blue.shade100,
                      Colors.green.shade100,
                      Colors.amber.shade100,
                      Colors.orange.shade100,
                    ];

                    // Иконки цвета
                    final iconColors = [
                      Colors.blue.shade700,
                      Colors.green.shade700,
                      Colors.amber.shade700,
                      Colors.orange.shade700,
                    ];

                    return InkWell(
                      onTap: () => _navigateToCategory(index, context),
                      child: Card(
                        color: colors[index],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icons[index],
                                size: 40, color: iconColors[index]),
                            const SizedBox(height: 12),
                            Text(
                              categories[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: iconColors[index],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
              ),
            ),

            // Рекомендации
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Рекомендации',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final titles = [
                          'Мечеть "Сердце Чечни"',
                          'Национальный музей',
                          'Чеченский национальный костюм',
                        ];
                        final subtitles = [
                          'Главная мечеть Чеченской Республики',
                          'Главный исторический музей республики',
                          'История и особенности традиционной одежды',
                        ];
                        final icons = [
                          Icons.place,
                          Icons.museum,
                          Icons.history_edu,
                        ];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 2,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12.0),
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                              radius: 24,
                              child: Icon(
                                icons[index],
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            title: Text(
                              titles[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(subtitles[index]),
                            trailing:
                                const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // _navigateToRecommendation(index, context);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Метод для создания карточки события
  Widget _buildEventCard(EventItem event) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Открыть событие: ${event.title}')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: event.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
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
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withAlpha((0.9 * 255).toInt()),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  event.date,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black45,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.description,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Colors.white.withAlpha((0.9 * 255).toInt()),
                                shadows: const [
                                  Shadow(
                                    blurRadius: 2.0,
                                    color: Colors.black38,
                                    offset: Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Метод для навигации по категориям
  void _navigateToCategory(int index, BuildContext context) {
    switch (index) {
      case 0: // Исторические памятники
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlacesListScreen(
              initialFilter: PlaceType.monument,
            ),
          ),
        );
        break;
      case 1: // Природа
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PlacesListScreen(
              initialFilter: PlaceType.nature,
            ),
          ),
        );
        break;
      case 2: // Ремесла
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TraditionsListScreen(
              initialFilter: TraditionCategory.crafts,
            ),
          ),
        );
        break;
      case 3: // Праздники
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TraditionsListScreen(
              initialFilter: TraditionCategory.holidays,
            ),
          ),
        );
        break;
    }
  }

  // Метод для навигации по рекомендациям
  // void _navigateToRecommendation(int index, BuildContext context) {
  //   switch (index) {
  //     case 0: // Мечеть "Сердце Чечни"
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PlaceDetailScreen(
  //             place: mockPlaces[0],
  //           ),
  //         ),
  //       );
  //     case 1: // Национальный музей
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PlaceDetailScreen(
  //             place: mockPlaces[1],
  //           ),
  //         ),
  //       );
  //       break;
  //     case 2: // Чеченский национальный костюм
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => TraditionDetailScreen(
  //             tradition: mockTraditions[0],
  //           ),
  //         ),
  //       );

  //       break;
  //   }
  // }
}
