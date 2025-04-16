import 'package:chechen_tradition/features/education/screens/content_detail_screen.dart';
import 'package:flutter/material.dart';
import '../../../models/education.dart';
import 'package:just_audio/just_audio.dart';
import 'package:chechen_tradition/features/education/screens/test_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Обновленные примерные данные с текстовым контентом
  final List<EducationalContent> _educationalContent = [
    EducationalContent(
      id: '1',
      title: 'История Грозного',
      description: 'История становления и развития столицы Чечни',
      type: ContentType.audio,
      audioUrl: 'assets/audio/grozny_history.mp3',
      content: '''
История города Грозного начинается с 1818 года, когда на берегу реки Сунжи была заложена крепость Грозная. Название крепости было дано по причине её грозного предназначения – она должна была держать в повиновении горские народы.

Первоначально крепость представляла собой военное укрепление, но постепенно вокруг неё стало формироваться гражданское поселение. К 1870 году крепость Грозная была преобразована в город Грозный.

В конце XIX века в окрестностях города были обнаружены богатые месторождения нефти, что дало мощный толчок развитию города. Грозный стал одним из крупнейших центров нефтедобычи и нефтепереработки в Российской империи.

В советский период город продолжал развиваться как важный промышленный центр. Здесь были построены новые заводы, открыт университет, развивалась культурная жизнь.
      ''',
      imageUrl: 'assets/images/grozny.jpg',
      questions: [
        Question(
          id: '1',
          question: 'В каком году был основан Грозный?',
          options: ['1818', '1850', '1870', '1900'],
          correctAnswerIndex: 0,
        ),
        Question(
          id: '2',
          question: 'Почему крепость назвали "Грозная"?',
          options: [
            'Из-за частых гроз',
            'Для устрашения горских народов',
            'В честь Ивана Грозного',
            'Из-за сурового климата'
          ],
          correctAnswerIndex: 1,
        ),
      ],
    ),
    // Добавьте другой контент
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Обучение',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Материалы'),
            Tab(text: 'Тесты'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMaterialsList(),
          _buildTestsList(),
        ],
      ),
    );
  }

  Widget _buildMaterialsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _educationalContent.length,
      itemBuilder: (context, index) {
        final content = _educationalContent[index];
        return ContentCard(
          content: content,
          onTap: () => _openContent(content),
        );
      },
    );
  }

  Widget _buildTestsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _educationalContent.length,
      itemBuilder: (context, index) {
        final content = _educationalContent[index];
        return TestCard(
          content: content,
          onTap: () => _openTest(content),
        );
      },
    );
  }

  void _openContent(EducationalContent content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentDetailScreen(content: content),
      ),
    );
  }

  void _openTest(EducationalContent content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestScreen(content: content),
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final EducationalContent content;
  final VoidCallback onTap;

  const ContentCard({
    Key? key,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                content.imageUrl,
                height: 150,
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
                    children: [
                      if (content.audioUrl != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B0000).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.headphones,
                                size: 16,
                                color: Color(0xFF8B0000),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Аудио',
                                style: TextStyle(
                                  color: Color(0xFF8B0000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (content.content != null)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF006400).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.article,
                                size: 16,
                                color: Color(0xFF006400),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Текст',
                                style: TextStyle(
                                  color: Color(0xFF006400),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  if (content.progress > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: content.progress,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF006400),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(content.progress * 100).round()}%',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF006400),
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
    );
  }
}

class TestCard extends StatelessWidget {
  final EducationalContent content;
  final VoidCallback onTap;

  const TestCard({
    Key? key,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B0000).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.quiz,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Тест: ${content.title}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${content.questions.length} вопросов',
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
              if (content.progress > 0) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: content.progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF006400),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(content.progress * 100).round()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF006400),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
