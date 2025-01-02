import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_event.dart';
import 'package:flutter_ebook_store/bloc/e_book_state.dart';

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
                        onPressed: () {
                          _editBook(context, book);
                        },
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
        onPressed: () {
          _addBook(context);
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _addBook(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String author = '';
        String price = '';
        String rating = '';
        String pages = '';
        String language = '';
        String description = '';
        String imagePath = '';

        return AlertDialog(
          title: const Text("Add New Book"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Title", (value) => title = value),
                _buildTextField("Author", (value) => author = value),
                _buildNumberField("Price", (value) => price = value),
                _buildNumberField("Rating (1-5)", (value) => rating = value,
                    min: 1, max: 5),
                _buildNumberField("Pages", (value) => pages = value, min: 1),
                _buildTextField("Language", (value) => language = value),
                _buildTextField("Description", (value) => description = value),
                _buildTextField("Image URL", (value) => imagePath = value),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<EbookBloc>().add(AddEbook(
                      title: title,
                      author: author,
                      price: double.parse(price),
                      rating: double.parse(rating),
                      pages: int.parse(pages),
                      language: language,
                      description: description,
                      imagePath: imagePath,
                    ));
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editBook(BuildContext context, dynamic book) {
    showDialog(
      context: context,
      builder: (context) {
        String title = book.title;
        String author = book.author;
        String price = book.price.toString();
        String rating = book.rating.toString();
        String pages = book.pages.toString();
        String language = book.language;
        String description = book.description;
        String imagePath = book.imagePath;

        return AlertDialog(
          title: const Text("Edit Book"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField("Title", (value) => title = value, title),
                _buildTextField("Author", (value) => author = value, author),
                _buildNumberField("Price", (value) => price = value,
                    initialValue: price),
                _buildNumberField("Rating (1-5)", (value) => rating = value,
                    initialValue: rating, min: 1, max: 5),
                _buildNumberField("Pages", (value) => pages = value,
                    initialValue: pages, min: 1),
                _buildTextField(
                    "Language", (value) => language = value, language),
                _buildTextField(
                    "Description", (value) => description = value, description),
                _buildTextField(
                    "Image URL", (value) => imagePath = value, imagePath),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<EbookBloc>().add(UpdateEbook(
                      id: book.id,
                      title: title,
                      author: author,
                      price: double.parse(price),
                      rating: double.parse(rating),
                      pages: int.parse(pages),
                      language: language,
                      description: description,
                      imagePath: imagePath,
                    ));
                Navigator.of(context).pop();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      [String initialValue = '']) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: initialValue),
    );
  }

  Widget _buildNumberField(String label, Function(String) onChanged,
      {String? initialValue, int? min, int? max}) {
    return TextField(
      onChanged: (value) {
        final parsedValue = double.tryParse(value) ?? 0.0;
        if (min != null && max != null) {
          final clampedValue = parsedValue.clamp(min, max);
          onChanged(clampedValue.toString());
        } else {
          onChanged(parsedValue.toString());
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      controller: TextEditingController(text: initialValue),
    );
  }
}
