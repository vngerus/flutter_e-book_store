import '../models/ebook_models.dart';

abstract class EbookEvent {}

class FetchEbooks extends EbookEvent {}

class AddEbook extends EbookEvent {
  final String title;
  final String author;
  final double price;
  final double rating;
  final int pages;
  final String language;
  final String description;
  final String imagePath;

  AddEbook({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.pages,
    required this.language,
    required this.description,
    required this.imagePath,
  });
}

class UpdateEbook extends EbookEvent {
  final String id;
  final String title;
  final String author;
  final double price;
  final double rating;
  final int pages;
  final String language;
  final String description;
  final String imagePath;

  UpdateEbook({
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
}

class DeleteEbook extends EbookEvent {
  final String id;

  DeleteEbook(this.id);
}

class AddToCart extends EbookEvent {
  final EbookModel book;
  final int quantity;

  AddToCart({required this.book, required this.quantity});
}

class RemoveFromCart extends EbookEvent {
  final EbookModel book;

  RemoveFromCart(this.book);
}

class UpdateCartItem extends EbookEvent {
  final EbookModel book;
  final int quantity;

  UpdateCartItem({required this.book, required this.quantity});
}

class ClearCart extends EbookEvent {}
