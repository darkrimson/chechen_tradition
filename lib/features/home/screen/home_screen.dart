import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                      child: SearchBar(
                        hintText: 'Поиск мест, событий, статей...',
                        leading: const Icon(Icons.search),
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SettingsScreen(),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Карусель событий
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text('Событие ${index + 1}'),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Категории
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
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

                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icons[index], size: 32),
                          const SizedBox(height: 8),
                          Text(
                            categories[index],
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 4,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
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
                    const Text(
                      'Рекомендации',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.place),
                            title: Text('Рекомендация ${index + 1}'),
                            subtitle: const Text('Краткое описание места'),
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
}
