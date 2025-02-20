class Tradition {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final TraditionCategory category;
  bool isLiked;

  Tradition({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.category,
    this.isLiked = false,
  });
}

enum TraditionCategory {
  clothing('Одежда', 'assets/icons/clothing.png'),
  cuisine('Кухня', 'assets/icons/cuisine.png'),
  crafts('Ремесла', 'assets/icons/crafts.png'),
  holidays('Праздники', 'assets/icons/holidays.png');

  final String label;
  final String iconPath;
  const TraditionCategory(this.label, this.iconPath);
}
