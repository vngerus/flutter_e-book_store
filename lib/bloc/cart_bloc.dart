import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_ebook_store/models/cart_models.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final Dio _dio = Dio();
  final List<CartItem> _cart = [];
  final List<CartItem> _purchasedBooks = [];

  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<UpdateCartItem>(_onUpdateCartItem);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<ClearCart>(_onClearCart);
    on<LoadCart>(_onLoadCart);
    on<CompletePurchase>(_onCompletePurchase);

    _loadCartFromFirebase();
    _loadPurchasedBooksFromFirebase();
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final existingItemIndex =
        _cart.indexWhere((item) => item.book.id == event.book.id);

    if (existingItemIndex != -1) {
      _cart[existingItemIndex].quantity += event.quantity;
    } else {
      _cart.add(CartItem(book: event.book, quantity: event.quantity));
    }

    _saveCartToFirebase();
    emit(CartLoaded(List.from(_cart)));
  }

  void _onUpdateCartItem(UpdateCartItem event, Emitter<CartState> emit) {
    final existingItemIndex =
        _cart.indexWhere((item) => item.book.id == event.book.id);

    if (existingItemIndex != -1) {
      if (event.quantity > 0) {
        _cart[existingItemIndex].quantity = event.quantity;
      } else {
        _cart.removeAt(existingItemIndex);
      }

      _saveCartToFirebase();
      emit(CartLoaded(List.from(_cart)));
    }
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    _cart.removeWhere((item) => item.book.id == event.book.id);
    _saveCartToFirebase();
    emit(CartLoaded(List.from(_cart)));
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    _cart.clear();
    _saveCartToFirebase();
    emit(CartLoaded(List.from(_cart)));
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    await _loadCartFromFirebase();
  }

  Future<void> _onCompletePurchase(
      CompletePurchase event, Emitter<CartState> emit) async {
    try {
      _purchasedBooks.addAll(event.purchasedBooks.map(
        (book) => CartItem(book: book, quantity: 1),
      ));
      await _savePurchasedBooksToFirebase();

      _cart.clear();
      await _saveCartToFirebase();

      emit(CartLoaded(List.from(_cart)));
    } catch (e) {
      emit(CartError("Failed to complete purchase: $e"));
    }
  }

  Future<void> _saveCartToFirebase() async {
    final cartData = _cart.map((item) => item.toJson()).toList();
    try {
      await _dio.put(
        'https://ebook-e2025-default-rtdb.firebaseio.com/cart.json',
        data: cartData,
      );
    } catch (e) {
      emit(CartError("Failed to save cart: $e"));
    }
  }

  Future<void> _loadCartFromFirebase() async {
    try {
      final response = await _dio.get(
        'https://ebook-e2025-default-rtdb.firebaseio.com/cart.json',
      );

      if (response.data != null) {
        final cartData = (response.data as List<dynamic>)
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList();

        _cart.clear();
        _cart.addAll(cartData);
        emit(CartLoaded(List.from(_cart)));
      } else {
        emit(CartLoaded([]));
      }
    } catch (e) {
      emit(CartError("Failed to load cart: $e"));
    }
  }

  Future<void> _savePurchasedBooksToFirebase() async {
    final purchasedData = _purchasedBooks.map((item) => item.toJson()).toList();
    try {
      await _dio.put(
        'https://ebook-e2025-default-rtdb.firebaseio.com/purchasedBooks.json',
        data: purchasedData,
      );
    } catch (e) {
      emit(CartError("Failed to save purchased books: $e"));
    }
  }

  Future<void> _loadPurchasedBooksFromFirebase() async {
    try {
      final response = await _dio.get(
        'https://ebook-e2025-default-rtdb.firebaseio.com/purchasedBooks.json',
      );

      if (response.data != null) {
        final purchasedData = (response.data as List<dynamic>)
            .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
            .toList();

        _purchasedBooks.clear();
        _purchasedBooks.addAll(purchasedData);
      }
    } catch (e) {
      emit(CartError("Failed to load purchased books: $e"));
    }
  }
}
