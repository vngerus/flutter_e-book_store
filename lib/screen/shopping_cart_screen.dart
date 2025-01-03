import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carro de compras"),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state is CartState) {
            final cartItems = state.cartItems;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          cartItem.book.imagePath,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                        title: Text(cartItem.book.title),
                        subtitle: Text(
                          "By ${cartItem.book.author} - \$${cartItem.book.price.toStringAsFixed(2)}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  context.read<EbookBloc>().add(UpdateCartItem(
                                        book: cartItem.book,
                                        quantity: cartItem.quantity - 1,
                                      ));
                                } else {
                                  context.read<EbookBloc>().add(
                                        RemoveFromCart(cartItem.book),
                                      );
                                }
                              },
                            ),
                            Text(
                              "${cartItem.quantity}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Colors.green),
                              onPressed: () {
                                context.read<EbookBloc>().add(UpdateCartItem(
                                      book: cartItem.book,
                                      quantity: cartItem.quantity + 1,
                                    ));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Total: \$${state.totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Checkout functionality pending"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                  ),
                  child: const Text("Checkout"),
                ),
              ],
            );
          }

          return const Center(
            child: Text("No items in the cart."),
          );
        },
      ),
    );
  }
}
