import 'package:flutter/material.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';

class BookFormWidget extends StatefulWidget {
  final EbookModel? book;
  final Function(EbookModel) onSubmit;
  final bool showTitle;

  const BookFormWidget({
    super.key,
    this.book,
    required this.onSubmit,
    this.showTitle = true,
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
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColor.bg2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.bg1, width: 3),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showTitle)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    widget.book == null ? "Add New Book" : "Edit Book",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.texto3,
                    ),
                  ),
                ),
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.texto3,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColor.bg1),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onSubmit(EbookModel(
                          id: widget.book?.id ?? '',
                          title: title,
                          author: author,
                          price: double.tryParse(price) ?? 0.0,
                          rating:
                              double.tryParse(rating)?.clamp(1.0, 5.0) ?? 1.0,
                          pages: int.tryParse(pages) ?? 0,
                          language: language,
                          description: description,
                          imagePath: imagePath,
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.bg1,
                      foregroundColor: AppColor.texto2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(widget.book == null ? "Add" : "Update"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      [String initialValue = '']) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColor.texto3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.bg1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.bg1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.texto3, width: 2),
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberField(String label, Function(String) onChanged,
      [String initialValue = '']) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppColor.texto3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.bg1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.bg1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColor.texto3, width: 2),
          ),
        ),
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
      ),
    );
  }
}
