import '../models/ebook_models.dart';

abstract class EbookState {}

class EbookInitial extends EbookState {}

class EbookLoading extends EbookState {}

class EbookLoaded extends EbookState {
  final List<EbookModel> ebooks;

  EbookLoaded(this.ebooks);
}

class EbookError extends EbookState {
  final String message;

  EbookError(this.message);
}

class CartState extends EbookState {
  final List<CartItem> cartItems;

  CartState(this.cartItems);

  double get totalPrice => cartItems.fold(
      0.0, (total, item) => total + (item.book.price * item.quantity));
}
