import 'package:flutter/material.dart';

class ContinueReadingWidget extends StatelessWidget {
  const ContinueReadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Continue Reading",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildBookCard(
                title: "Fred the Lonely Monster",
                author: "By Tara Westover",
                imagePath: "assets/img/tolkien_tlor.png",
                progress: "65%",
                rating: 4.5,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookCard({
    required String title,
    required String author,
    required String imagePath,
    required String progress,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              height: 80,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  author,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  progress,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
