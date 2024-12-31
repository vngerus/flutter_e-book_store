import 'package:equatable/equatable.dart';

class BookModel extends Equatable {
  final String id;
  final String title;
  final String author;
  final double price;
  final String imageUrl;
  final bool isFavorite;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Untitled',
      author: json['author'] ?? 'Unknown Author',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }

  @override
  List<Object?> get props => [id, title, author, price, imageUrl, isFavorite];
}
