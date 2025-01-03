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
  final bool isBookmarked; // Campo agregado

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
    this.isBookmarked = false,
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
      isBookmarked: json['isBookmarked'] as bool? ??
          false, // Recuperar el estado de bookmark
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
      'isBookmarked': isBookmarked,
    };
  }

  EbookModel copyWith({
    String? title,
    String? author,
    double? price,
    double? rating,
    int? pages,
    String? language,
    String? description,
    String? imagePath,
    bool? isBookmarked,
  }) {
    return EbookModel(
      id: id,
      title: title ?? this.title,
      author: author ?? this.author,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      pages: pages ?? this.pages,
      language: language ?? this.language,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}

class CartItem {
  final EbookModel book;
  int quantity;

  CartItem({required this.book, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'book': book.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final bookData = json['book'] as Map<String, dynamic>;
    final bookId = bookData['id'] ?? '';
    return CartItem(
      book: EbookModel.fromJson(bookId, bookData),
      quantity: json['quantity'] as int,
    );
  }
}
