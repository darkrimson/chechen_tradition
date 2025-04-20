import 'package:chechen_tradition/data/places/mock_places.dart';
import 'package:chechen_tradition/data/traditions/mock_traditions.dart';
import 'package:chechen_tradition/features/main/settings/ui/settings_screen.dart';
import 'package:chechen_tradition/features/main/search/ui/search_page.dart';
import 'package:chechen_tradition/features/places/ui/place/place_detail_screen.dart';
import 'package:chechen_tradition/features/places/ui/place/places_list_screen.dart';
import 'package:chechen_tradition/features/places/models/culture_place.dart';
import 'package:chechen_tradition/features/traditions/ui/tradition_detail_screen.dart';
import 'package:chechen_tradition/features/traditions/ui/traditions_list_screen.dart';
import 'package:chechen_tradition/features/traditions/models/tradition.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Модель события
  final List<EventItem> _events = [
    EventItem(
      title: 'День чеченского языка',
      description: 'Ежегодный праздник, посвященный чеченскому языку',
      date: '25 апреля',
      imageUrl: 'assets/images/chechen_language.jpg',
      color: Colors.indigo.shade300,
    ),
    EventItem(
      title: 'Фестиваль культуры',
      description: 'Традиционный фестиваль чеченской культуры в Грозном',
      date: '10 мая',
      imageUrl: 'assets/images/festival.jpg',
      color: Colors.orange.shade300,
    ),
    EventItem(
      title: 'Выставка ремесел',
      description: 'Выставка традиционных чеченских ремесел и мастер-классы',
      date: '15 июня',
      imageUrl: 'assets/images/crafts.jpg',
      color: Colors.teal.shade300,
    ),
    EventItem(
      title: 'Исторический форум',
      description: 'Международный форум по истории Северного Кавказа',
      date: '20 июля',
      imageUrl: 'assets/images/history.jpg',
      color: Colors.purple.shade300,
    ),
    EventItem(
      title: 'Этнический концерт',
      description: 'Концерт традиционной чеченской музыки',
      date: '5 августа',
      imageUrl: 'assets/images/music.jpg',
      color: Colors.deepOrange.shade300,
    ),
  ];

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
                              builder: (context) => const SearchPage(),
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
                      itemCount: _events.length,
                      controller: PageController(viewportFraction: 0.9),
                      onPageChanged: (index) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildEventCard(_events[index]);
                      },
                    ),
                  ),
                  // Индикаторы страниц
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _events.length,
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
                              _navigateToRecommendation(index, context);
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
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  event.color,
                  event.color.withOpacity(0.7),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: AssetImage(event.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              color: Colors.white.withOpacity(0.9),
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
                          color: Colors.white.withOpacity(0.9),
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
  void _navigateToRecommendation(int index, BuildContext context) {
    switch (index) {
      case 0: // Мечеть "Сердце Чечни"
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(
              place: mockPlaces[0],
            ),
          ),
        );
      case 1: // Национальный музей
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(
              place: mockPlaces[1],
            ),
          ),
        );
        break;
      case 2: // Чеченский национальный костюм
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TraditionDetailScreen(
              tradition: mockTraditions[0],
            ),
          ),
        );

        break;
    }
  }
}

// Модель для событий
class EventItem {
  final String title;
  final String description;
  final String date;
  final String imageUrl;
  final Color color;

  EventItem({
    required this.title,
    required this.description,
    required this.date,
    required this.imageUrl,
    required this.color,
  });
}
