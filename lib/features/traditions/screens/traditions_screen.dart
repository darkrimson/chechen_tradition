import 'package:flutter/material.dart';
import '../../../models/tradition.dart';
import '../widgets/category_card.dart';
import '../widgets/tradition_card.dart';
import 'tradition_detail_screen.dart';

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
    Tradition(
      id: '2',
      title: 'Жижиг-галнаш',
      description: 'Традиционное чеченское блюдо из мяса и галушек',
      content: '''
Жижиг-галнаш - одно из самых популярных блюд чеченской кухни. Готовится из отварного мяса 
(обычно баранины или говядины) и галушек из пшеничной или кукурузной муки. Подается с чесночным 
соусом и бульоном. Это блюдо традиционно готовится для важных семейных событий и праздников.
    ''',
      imageUrl: 'assets/images/zhizhig-galnash.jpg',
      category: TraditionCategory.cuisine,
    ),
    Tradition(
      id: '3',
      title: 'Золотое шитье',
      description: 'Искусство вышивки золотыми нитями',
      content: '''
Золотое шитье - древнее ремесло чеченских мастериц. Техника включает вышивку золотыми и 
серебряными нитями по бархату и другим дорогим тканям. Этим способом украшают национальные 
костюмы, предметы быта и декоративные панно. Каждый узор имеет свое значение и историю.
    ''',
      imageUrl: 'assets/images/gold-embroidery.jpg',
      category: TraditionCategory.crafts,
    ),
    Tradition(
      id: '4',
      title: 'Ураза-Байрам',
      description: 'Главный исламский праздник разговения',
      content: '''
Ураза-Байрам (Ид аль-Фитр) - один из главных исламских праздников, отмечающий окончание 
месяца Рамадан. В этот день принято совершать праздничную молитву, навещать родственников, 
готовить традиционные блюда и делать пожертвования нуждающимся. Праздник способствует 
укреплению семейных и общественных связей.
    ''',
      imageUrl: 'assets/images/eid.jpg',
      category: TraditionCategory.holidays,
    ),
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
      body: Column(
        children: [
          // Панель категорий
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: TraditionCategory.values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = TraditionCategory.values[index];
                return CategoryCard(
                  category: category,
                  isSelected: selectedCategory == category,
                  onTap: () {
                    setState(() {
                      selectedCategory =
                          selectedCategory == category ? null : category;
                    });
                  },
                );
              },
            ),
          ),
          // Список традиций
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: traditions.length,
              itemBuilder: (context, index) {
                final tradition = traditions[index];
                if (selectedCategory != null &&
                    tradition.category != selectedCategory) {
                  return const SizedBox.shrink();
                }
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
            ),
          ),
        ],
      ),
    );
  }
}
