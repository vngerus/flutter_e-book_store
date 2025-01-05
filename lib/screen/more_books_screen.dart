import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/book_detail_screen.dart';
import 'package:flutter_ebook_store/models/ebook_models.dart';
import '../widgets/app_colors.dart';

class MoreBooksScreen extends StatelessWidget {
  final List<EbookModel> books;

  const MoreBooksScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "More Books",
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
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColor.texto3),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: AppColor.bg2,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return GestureDetector(
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
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColor.bg2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColor.bg1, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              book.imagePath,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error,
                                      color: Colors.red),
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
          ],
        ),
      ),
    );
  }
}
