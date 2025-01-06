import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_event.dart';
import '../bloc/e_book_bloc.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';
import '../widgets/book_form_widget.dart';

class AddBookScreen extends StatelessWidget {
  final EbookModel? book;

  const AddBookScreen({super.key, this.book});

  @override
  Widget build(BuildContext context) {
    final isEditing = book != null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isEditing ? "Edit Book" : "Add New Book",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BookFormWidget(
          book: book,
          showTitle: false,
          onSubmit: (EbookModel newBook) {
            if (isEditing) {
              context.read<EbookBloc>().add(UpdateEbook(
                    id: book!.id,
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
            }
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
