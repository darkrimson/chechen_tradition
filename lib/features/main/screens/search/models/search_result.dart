enum SearchResultType {
  place('Место'),
  tradition('Традиция'),
  education('Образование');

  final String displayName;
  const SearchResultType(this.displayName);
}

class SearchResult {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final SearchResultType type;
  final dynamic originalItem; // Оригинальный объект для навигации

  SearchResult({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.type,
    required this.originalItem,
  });
}
