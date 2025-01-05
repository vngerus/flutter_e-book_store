import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/books_by_author_screen.dart';
import '../widgets/app_colors.dart';

class AuthorsCarrouselWidget extends StatelessWidget {
  final List<String> authors;

  const AuthorsCarrouselWidget({super.key, required this.authors});

  @override
  Widget build(BuildContext context) {
    final List<String> displayedAuthors =
        authors.length > 5 ? authors.sublist(0, 5) : authors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Authors",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColor.texto3,
                ),
              ),
              if (authors.length > 5)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const BooksByAuthorScreen(author: "All Authors"),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        "More Authors",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.texto2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: AppColor.texto2,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: displayedAuthors.length,
            itemBuilder: (context, index) {
              final author = displayedAuthors[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bg2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColor.bg1, width: 2),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BooksByAuthorScreen(author: author),
                      ),
                    );
                  },
                  child: Text(
                    author,
                    style: TextStyle(color: AppColor.texto3),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
