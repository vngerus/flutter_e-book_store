import 'package:flutter_ebook_store/models/ebook_models.dart';

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
