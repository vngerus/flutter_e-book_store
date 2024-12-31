import 'package:flutter/material.dart';

class BookCarousel extends StatelessWidget {
  const BookCarousel({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trending Book",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.more_horiz),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(book["image"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: Text(
                        "by ${book["author"]!}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        book["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
