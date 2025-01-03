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
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 1.0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
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

class CartItem {
  final EbookModel book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});
}
