import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_state.dart';
import 'package:flutter_ebook_store/models/cart_models.dart';
import 'package:flutter_ebook_store/models/ebook_models.dart';
import 'package:flutter_ebook_store/screen/reading_detail_screen.dart';
import 'package:flutter_ebook_store/widgets/app_colors.dart';

class ContinueReadingWidget extends StatelessWidget {
  const ContinueReadingWidget(
      {super.key, required List<EbookModel> readingBooks});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          List<CartItem> readingBooks = [];

          if (state is PurchasedBooksLoaded) {
            readingBooks = state.purchasedBooks
                .where((item) => item.progress > 0)
                .toList();
          }

          return DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.bg1,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: CustomPaint(
                    painter: DottedBackgroundPainter(),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColor.texto2,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Continue Reading",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.texto3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (state is CartLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (state is CartError)
                          Center(
                            child: Text(
                              "Error: ${state.message}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        else if (readingBooks.isEmpty)
                          Center(
                            child: Text(
                              "Sart reading books",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColor.texto2,
                              ),
                            ),
                          )
                        else
                          ...readingBooks.map((cartItem) {
                            final book = cartItem.book;
                            return _buildBookCard(
                              title: book.title,
                              author: book.author,
                              imagePath: book.imagePath,
                              progress: cartItem.progress,
                              rating: book.rating,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReadingDetailScreen(
                                      book: book,
                                      onProgressUpdated: (double newProgress) {
                                        context
                                            .read<CartBloc>()
                                            .updateBookProgress(
                                                book.id, newProgress);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBookCard({
    required String title,
    required String author,
    required String imagePath,
    required double progress,
    required double rating,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        color: AppColor.bg2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imagePath,
                  height: 80,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const SizedBox(
                        height: 80,
                        width: 60,
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.texto3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.texto3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < rating.round()
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white,
                      color: AppColor.aquagreen,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 50,
                width: 50,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColor.white,
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
                      "${(progress * 100).round()}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColor.coral,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.bg1
      ..style = PaintingStyle.fill;

    const double spacing = 3;
    const double radius = 3;

    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
