import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';

class BookmarkScreen extends StatelessWidget {
  final VoidCallback onBack;

  const BookmarkScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bookmarks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            onBack();
          },
        ),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state is EbookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EbookLoaded) {
            final bookmarkedBooks =
                state.ebooks.where((ebook) => ebook.isBookmarked).toList();

            if (bookmarkedBooks.isEmpty) {
              return const Center(
                child: Text(
                  'No bookmarks yet.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return Center(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemCount: bookmarkedBooks.length,
                itemBuilder: (context, index) {
                  final book = bookmarkedBooks[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(book.imagePath),
                                  fit: BoxFit.cover,
                                ),
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
                                  Text(
                                    "By ${book.author}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.bookmark,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                context
                                    .read<EbookBloc>()
                                    .add(ToggleBookmark(bookId: book.id));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Failed to load bookmarks.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
