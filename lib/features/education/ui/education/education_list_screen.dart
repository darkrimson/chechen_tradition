import 'package:cached_network_image/cached_network_image.dart';
import 'package:chechen_tradition/features/education/provider/education_provider.dart';
import 'package:chechen_tradition/features/education/ui/education/education_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/education.dart';
import '../test/test_list_screen.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationProvider>(context);
    final educationalContent = provider.educationalContent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Обучение'),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Материалы'),
            Tab(text: 'Тесты'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMaterialsList(educationalContent),
          TestListScreen(educationalContent: educationalContent),
        ],
      ),
    );
  }

  Widget _buildMaterialsList(List<Education> contentList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        final content = contentList[index];
        return ContentCard(
          content: content,
          onTap: () => _openContent(content),
        );
      },
    );
  }

  void _openContent(Education content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EducationDetailScreen(content: content),
      ),
    );
  }
}

class ContentCard extends StatelessWidget {
  final Education content;
  final VoidCallback onTap;

  const ContentCard({
    super.key,
    required this.content,
    required this.onTap,
  });

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
              child: Hero(
                tag: 'content-${content.id}',
                child: CachedNetworkImage(
                  imageUrl: content.imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(content.progress * 100).round()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
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
