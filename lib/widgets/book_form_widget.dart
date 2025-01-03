import 'package:flutter/material.dart';
import '../models/ebook_models.dart';

class BookFormWidget extends StatefulWidget {
  final EbookModel? book;
  final Function(EbookModel) onSubmit;

  const BookFormWidget({
    super.key,
    this.book,
    required this.onSubmit,
  });

  @override
  _BookFormWidgetState createState() => _BookFormWidgetState();
}

class _BookFormWidgetState extends State<BookFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String author;
  late String price;
  late String rating;
  late String pages;
  late String language;
  late String description;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    final book = widget.book;
    title = book?.title ?? '';
    author = book?.author ?? '';
    price = book?.price.toString() ?? '';
    rating = book?.rating.toString() ?? '';
    pages = book?.pages.toString() ?? '';
    language = book?.language ?? '';
    description = book?.description ?? '';
    imagePath = book?.imagePath ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.book == null ? "Add New Book" : "Edit Book"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField("Title", (value) => title = value, title),
              _buildTextField("Author", (value) => author = value, author),
              _buildNumberField("Price", (value) => price = value, price),
              _buildNumberField(
                  "Rating (1-5)", (value) => rating = value, rating),
              _buildNumberField("Pages", (value) => pages = value, pages),
              _buildTextField(
                  "Language", (value) => language = value, language),
              _buildTextField(
                  "Description", (value) => description = value, description),
              _buildTextField(
                  "Image URL", (value) => imagePath = value, imagePath),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(EbookModel(
                id: widget.book?.id ?? '',
                title: title,
                author: author,
                price: double.tryParse(price) ?? 0.0,
                rating: double.tryParse(rating)?.clamp(1.0, 5.0) ?? 1.0,
                pages: int.tryParse(pages) ?? 0,
                language: language,
                description: description,
                imagePath: imagePath,
              ));
            }
          },
          child: Text(widget.book == null ? "Add" : "Update"),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      [String initialValue = '']) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        return null;
      },
    );
  }

  Widget _buildNumberField(String label, Function(String) onChanged,
      [String initialValue = '']) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required";
        }
        if (double.tryParse(value) == null) {
          return "$label must be a number";
        }
        return null;
      },
    );
  }
}
