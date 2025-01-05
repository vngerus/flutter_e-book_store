import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/books_by_author_screen.dart';
import '../widgets/app_colors.dart';

class AuthorsScreen extends StatelessWidget {
  final List<String> authors;

  const AuthorsScreen({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Authors",
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
            childAspectRatio: 2.5,
          ),
          itemCount: authors.length,
          itemBuilder: (context, index) {
            final author = authors[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BooksByAuthorScreen(author: author),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColor.bg1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.bg2, width: 2),
                ),
                child: Center(
                  child: Text(
                    author,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColor.texto3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
