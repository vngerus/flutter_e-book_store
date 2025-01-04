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
  final bool isBookmarked;
  final double progress;

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
    double progress = 0.0,
  }) : progress = progress.clamp(0.0, 1.0);

  factory EbookModel.empty() {
    return EbookModel(
      id: '',
      title: '',
      author: '',
      price: 0.0,
      rating: 0.0,
      pages: 0,
      language: '',
      description: '',
      imagePath: '',
      isBookmarked: false,
      progress: 0.0,
    );
  }

  EbookModel copyWith({
    String? id,
    String? title,
    String? author,
    double? price,
    double? rating,
    int? pages,
    String? language,
    String? description,
    String? imagePath,
    bool? isBookmarked,
    double? progress,
  }) {
    return EbookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      pages: pages ?? this.pages,
      language: language ?? this.language,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      progress: (progress ?? this.progress).clamp(0.0, 1.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'price': price,
      'rating': rating,
      'pages': pages,
      'language': language,
      'description': description,
      'imagePath': imagePath,
      'isBookmarked': isBookmarked,
      'progress': progress,
    };
  }

  factory EbookModel.fromJson(String id, Map<String, dynamic> json) {
    return EbookModel(
      id: id,
      title: json['title'] as String? ?? '',
      author: json['author'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imagePath: json['imagePath'] as String? ?? '',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      progress: (json['progress'] as num?)?.toDouble().clamp(0.0, 1.0) ?? 0.0,
    );
  }
}
