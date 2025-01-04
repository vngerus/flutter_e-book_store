import 'package:flutter_ebook_store/models/ebook_models.dart';

class CartItem {
  final EbookModel book;
  int quantity;
  double progress;

  CartItem({
    required this.book,
    this.quantity = 1,
    this.progress = 0.0,
  });

  CartItem copyWith({
    EbookModel? book,
    int? quantity,
    double? progress,
  }) {
    return CartItem(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book.toJson(),
      'quantity': quantity,
      'progress': progress,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final bookData = json['book'] as Map<String, dynamic>;
    final bookId = bookData['id'] ?? '';
    return CartItem(
      book: EbookModel.fromJson(bookId, bookData),
      quantity: json['quantity'] as int? ?? 1,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
