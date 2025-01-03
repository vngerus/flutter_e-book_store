import '../models/ebook_models.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final EbookModel book;
  final int quantity;

  AddToCart({required this.book, required this.quantity});
}

class UpdateCartItem extends CartEvent {
  final EbookModel book;
  final int quantity;

  UpdateCartItem({required this.book, required this.quantity});
}

class RemoveFromCart extends CartEvent {
  final EbookModel book;

  RemoveFromCart(this.book);
}

class ClearCart extends CartEvent {}

class LoadCart extends CartEvent {}
