import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_state.dart';
import 'package:flutter_ebook_store/screen/reading_detail_screen.dart';

class ContinueReadingWidget extends StatelessWidget {
  const ContinueReadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state is EbookLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EbookLoaded) {
            final readingBooks =
                state.ebooks.where((book) => book.progress > 0).toList();
            final book = readingBooks.isNotEmpty ? readingBooks[0] : null;

            return DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Continue Reading",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (book == null)
                        const Center(
                          child: Text(
                            "No books to continue reading.",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else
                        _buildBookCard(
                          title: book.title,
                          author: book.author,
                          imagePath: book.imagePath,
                          progress: book.progress,
                          rating: book.rating,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReadingDetailScreen(
                                  book: book,
                                  onProgressUpdated: (double) {},
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                );
              },
            );
          } else if (state is EbookError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(
            child: Text(
              "Loading books...",
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookCard({
    required String title,
    required String author,
    required String imagePath,
    required double progress,
    required double rating,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imagePath,
                height: 80,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 80,
                    width: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating.round() ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
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
            SizedBox(
              height: 50,
              width: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "${(progress * 100).round()}%",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
