import 'package:flutter_ebook_store/models/cart_models.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);

  double get totalPrice => cartItems.fold(
      0.0, (total, item) => total + (item.book.price * item.quantity));
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}
