import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';
import 'book_detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  final VoidCallback onBack;

  const BookmarkScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centrar el título del AppBar
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
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          book.imagePath,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                      title: Text(book.title),
                      subtitle: Text("By ${book.author}"),
                      trailing: IconButton(
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailScreen(
                              bookData: {
                                'id': book.id,
                                'title': book.title,
                                'author': book.author,
                                'price': book.price,
                                'rating': book.rating,
                                'pages': book.pages,
                                'language': book.language,
                                'description': book.description,
                                'imagePath': book.imagePath,
                              },
                            ),
                          ),
                        );
                      },
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
