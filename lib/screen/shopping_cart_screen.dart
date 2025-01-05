import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/payment/payment_method_screen.dart';
import 'package:flutter_ebook_store/widgets/app_colors.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../models/ebook_models.dart';

class ShoppingCartScreen extends StatelessWidget {
  final Function(List<EbookModel>) onPurchaseComplete;

  const ShoppingCartScreen({super.key, required this.onPurchaseComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Shopping Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.texto3,
          ),
        ),
        backgroundColor: AppColor.bg1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColor.bg2,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;

            if (cartItems.isEmpty) {
              return const Center(
                child: Text(
                  "No items in the cart.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return Dismissible(
                        key: Key(cartItem.book.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          context
                              .read<CartBloc>()
                              .add(RemoveFromCart(cartItem.book));
                        },
                        background: Container(
                          color: AppColor.bg3,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.bg2,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColor.bg1, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    cartItem.book.imagePath,
                                    height: 130,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.book.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor.texto3,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "By ${cartItem.book.author}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColor.texto2,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove,
                                                    color: AppColor.texto3),
                                                onPressed: cartItem.quantity > 1
                                                    ? () {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              UpdateCartItem(
                                                                book: cartItem
                                                                    .book,
                                                                quantity: cartItem
                                                                        .quantity -
                                                                    1,
                                                              ),
                                                            );
                                                      }
                                                    : null,
                                              ),
                                              Text(
                                                "${cartItem.quantity}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: AppColor.coral,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add,
                                                    color: AppColor.texto3),
                                                onPressed: cartItem.quantity < 5
                                                    ? () {
                                                        context
                                                            .read<CartBloc>()
                                                            .add(
                                                              UpdateCartItem(
                                                                book: cartItem
                                                                    .book,
                                                                quantity: cartItem
                                                                        .quantity +
                                                                    1,
                                                              ),
                                                            );
                                                      }
                                                    : null,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _formatPrice(cartItem.book.price *
                                                cartItem.quantity),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: AppColor.coral,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColor.texto3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _formatPrice(state.totalPrice),
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColor.coral,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final purchasedBooks = cartItems
                                .map((cartItem) => cartItem.book)
                                .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentMethodScreen(
                                  purchasedBooks: purchasedBooks,
                                  onPurchaseComplete: onPurchaseComplete,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.bg1,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Payment",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColor.texto2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CartError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(
            child: Text("No items in the cart."),
          );
        },
      ),
    );
  }

  String _formatPrice(double price) {
    return price % 1 == 0
        ? "\$${price.toStringAsFixed(3)}"
        : "\$${price.toStringAsFixed(2)}";
  }
}
