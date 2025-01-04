import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';
import '../models/ebook_models.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookDetailScreen({super.key, required this.bookData});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int quantity = 1;
  late bool isSaved;
  late StreamSubscription _blocSubscription;

  @override
  void initState() {
    super.initState();

    final ebookBloc = context.read<EbookBloc>();
    final bookId = widget.bookData['id'];

    if (ebookBloc.state is EbookLoaded) {
      final books = (ebookBloc.state as EbookLoaded).ebooks;
      final book = books.firstWhere((ebook) => ebook.id == bookId,
          orElse: () => EbookModel.empty());
      isSaved = book.isBookmarked;
    } else {
      isSaved = widget.bookData['isBookmarked'] as bool? ?? false;
    }

    _blocSubscription = ebookBloc.stream.listen((state) {
      if (state is EbookLoaded) {
        final book = state.ebooks.firstWhere(
          (ebook) => ebook.id == bookId,
          orElse: () => EbookModel.empty(),
        );
        if (mounted) {
          setState(() {
            isSaved = book.isBookmarked;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _blocSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookData = widget.bookData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Detail Book",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                bookData['imagePath'] ?? 'https://via.placeholder.com/150',
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.6,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${(bookData['price'] ?? 0.0).toStringAsFixed(3)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            bookData['title'] ?? 'Unknown Title',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            setState(() {
                              isSaved = !isSaved;
                            });
                            context.read<EbookBloc>().add(
                                  ToggleBookmark(bookId: widget.bookData['id']),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSaved
                                      ? 'Book added to saved list!'
                                      : 'Book removed from saved list!',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Text(
                      "by ${bookData['author'] ?? 'Unknown Author'}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InfoTile(
                            label: "Rating",
                            value: "${bookData['rating'] ?? '0.0'}",
                          ),
                          InfoTile(
                            label: "Pages",
                            value: "${bookData['pages'] ?? '0'}",
                          ),
                          InfoTile(
                            label: "Language",
                            value: bookData['language'] ?? 'Unknown',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          bookData['description'] ??
                              'No description available.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "QTY",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) quantity--;
                          });
                        },
                      ),
                      Text(
                        "$quantity",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(
                          book: EbookModel(
                            id: bookData['id'],
                            title: bookData['title'],
                            author: bookData['author'],
                            price: bookData['price'],
                            rating: bookData['rating'],
                            pages: bookData['pages'],
                            language: bookData['language'],
                            description: bookData['description'],
                            imagePath: bookData['imagePath'],
                            isBookmarked: isSaved,
                          ),
                          quantity: quantity,
                        ));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Book added to cart!"),
                      ),
                    );
                  },
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
