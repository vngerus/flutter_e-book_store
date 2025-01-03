import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/widgets/book_form_widget.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';
import '../models/ebook_models.dart';

class BookManagerScreen extends StatelessWidget {
  const BookManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Books"),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state is EbookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EbookLoaded) {
            return ListView.builder(
              itemCount: state.ebooks.length,
              itemBuilder: (context, index) {
                final book = state.ebooks[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text("By ${book.author}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showBookForm(context, book: book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<EbookBloc>().add(DeleteEbook(book.id));
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
          return const Center(child: Text("No books available."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookForm(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _showBookForm(BuildContext context, {EbookModel? book}) {
    showDialog(
      context: context,
      builder: (context) {
        return BookFormWidget(
          book: book,
          onSubmit: (EbookModel newBook) {
            if (book == null) {
              context.read<EbookBloc>().add(AddEbook(
                    title: newBook.title,
                    author: newBook.author,
                    price: newBook.price,
                    rating: newBook.rating,
                    pages: newBook.pages,
                    language: newBook.language,
                    description: newBook.description,
                    imagePath: newBook.imagePath,
                  ));
            } else {
              context.read<EbookBloc>().add(UpdateEbook(
                    id: book.id,
                    title: newBook.title,
                    author: newBook.author,
                    price: newBook.price,
                    rating: newBook.rating,
                    pages: newBook.pages,
                    language: newBook.language,
                    description: newBook.description,
                    imagePath: newBook.imagePath,
                  ));
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
