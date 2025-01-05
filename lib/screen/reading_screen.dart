import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ebook_models.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';
import 'reading_detail_screen.dart';

class ReadingScreen extends StatelessWidget {
  final VoidCallback onBackToExplore;

  const ReadingScreen({
    super.key,
    required this.onBackToExplore,
    required List<EbookModel> purchasedBooks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Reading"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBackToExplore,
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PurchasedBooksLoaded &&
              state.purchasedBooks.isNotEmpty) {
            final purchasedBooks = state.purchasedBooks;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: purchasedBooks.length,
              itemBuilder: (context, index) {
                final cartItem = purchasedBooks[index];
                final book = cartItem.book;
                final progress = cartItem.progress;
                final bool isReading = progress > 0 && progress < 1.0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            book.imagePath,
                            height: 80,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "By ${book.author}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: List.generate(
                                  5,
                                  (starIndex) => Icon(
                                    Icons.star,
                                    color: starIndex < book.rating
                                        ? Colors.orange
                                        : Colors.grey[300],
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[200],
                                color: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadingDetailScreen(
                                  book: book,
                                  onProgressUpdated: (double newProgress) {
                                    context.read<CartBloc>().updateBookProgress(
                                        book.id, newProgress);
                                  },
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isReading ? Colors.grey : Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            isReading ? "Resume" : "Read",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                "No books available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }
}
