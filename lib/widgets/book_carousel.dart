import 'package:flutter/material.dart';

class BookCarousel extends StatelessWidget {
  final List<Map<String, String>> books = [
    {
      "title": "A Love Hate Thing",
      "author": "Whitney D. Grandison",
      "image": "assets/img/tolkien_tlor.png",
    },
    {
      "title": "Muscle Travel",
      "author": "Alan Trotter",
      "image": "assets/img/tolkien_tlor.png",
    },
    {
      "title": "Authority",
      "author": "Jeff VanderMeer",
      "image": "assets/img/tolkien_tlor.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/bookDetail',
                arguments: {
                  "title": book["title"]!,
                  "author": book["author"]!,
                  "image": book["image"]!,
                },
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      book["image"]!,
                      height: 200,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book["title"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "by ${book["author"]!}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
    );
  }
}
