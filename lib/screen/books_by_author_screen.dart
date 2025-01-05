import 'package:flutter/material.dart';
import '../widgets/app_colors.dart';
import '../models/ebook_models.dart';

class BooksByAuthorScreen extends StatelessWidget {
  final String author;

  const BooksByAuthorScreen({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final List<EbookModel> booksByAuthor = [
      EbookModel(
        id: '1',
        title: 'Book 1',
        author: author,
        imagePath: 'https://via.placeholder.com/150',
        price: 10.0,
        rating: 4.5,
        progress: 0.5,
        language: 'English',
        pages: 200,
        description: 'Description of Book 1',
      ),
      EbookModel(
        id: '2',
        title: 'Book 2',
        author: author,
        imagePath: 'https://via.placeholder.com/150',
        price: 12.0,
        rating: 4.0,
        progress: 0.7,
        language: 'Spanish',
        pages: 250,
        description: 'Description of Book 2',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Books by $author",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.texto3,
          ),
        ),
        backgroundColor: AppColor.bg1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.texto3),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColor.bg2,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: booksByAuthor.length,
          itemBuilder: (context, index) {
            final book = booksByAuthor[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColor.bg1,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.bg2, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        book.imagePath,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColor.texto3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "by ${book.author}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.texto2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
