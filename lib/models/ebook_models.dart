class EbookModel {
  final String id;
  final String title;
  final String author;
  final double price;
  final double rating;
  final int pages;
  final String language;
  final String description;
  final String imagePath;

  EbookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.pages,
    required this.language,
    required this.description,
    required this.imagePath,
  });

  factory EbookModel.fromJson(String id, Map<String, dynamic> json) {
    return EbookModel(
      id: id,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      pages: json['pages'] ?? 0,
      language: json['language'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'price': price,
      'rating': rating,
      'pages': pages,
      'language': language,
      'description': description,
      'imagePath': imagePath,
    };
  }
}
