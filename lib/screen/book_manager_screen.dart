import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/widgets/book_form_widget.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';

class BookManagerScreen extends StatelessWidget {
  const BookManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Manage Books",
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
      body: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          if (state is EbookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EbookLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: state.ebooks.length,
              itemBuilder: (context, index) {
                final book = state.ebooks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Dismissible(
                    key: Key(book.id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.centerLeft,
                      color: Colors.blue,
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.centerRight,
                      color: AppColor.coral,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _showBookForm(context, book: book);
                        return false;
                      } else if (direction == DismissDirection.endToStart) {
                        bool confirmDelete = await _confirmDelete(context);
                        if (confirmDelete) {
                          context.read<EbookBloc>().add(DeleteEbook(book.id));
                          return true;
                        }
                      }
                      return false;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.bg2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.bg1,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              height: 120,
                              width: 80,
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
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.texto3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "By ${book.author}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColor.texto2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () =>
                                      _showBookForm(context, book: book),
                                ),
                                IconButton(
                                  icon:
                                      Icon(Icons.delete, color: AppColor.coral),
                                  onPressed: () async {
                                    bool confirmDelete =
                                        await _confirmDelete(context);
                                    if (confirmDelete) {
                                      context
                                          .read<EbookBloc>()
                                          .add(DeleteEbook(book.id));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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
        backgroundColor: AppColor.bg1,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text("Are you sure you want to delete this book?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete"),
              ),
            ],
          ),
        ) ??
        false;
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
