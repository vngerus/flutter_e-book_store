import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/e_book_bloc.dart';
import '../bloc/e_book_event.dart';
import '../bloc/e_book_state.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookDetailScreen({super.key, required this.bookData});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int quantity = 1;
  late bool isSaved;
  late StreamSubscription _blocSubscription;

  @override
  void initState() {
    super.initState();

    final ebookBloc = context.read<EbookBloc>();
    final bookId = widget.bookData['id'];

    if (ebookBloc.state is EbookLoaded) {
      final books = (ebookBloc.state as EbookLoaded).ebooks;
      final book = books.firstWhere((ebook) => ebook.id == bookId,
          orElse: () => EbookModel.empty());
      isSaved = book.isBookmarked;
    } else {
      isSaved = widget.bookData['isBookmarked'] as bool? ?? false;
    }

    _blocSubscription = ebookBloc.stream.listen((state) {
      if (state is EbookLoaded) {
        final book = state.ebooks.firstWhere(
          (ebook) => ebook.id == bookId,
          orElse: () => EbookModel.empty(),
        );
        if (mounted) {
          setState(() {
            isSaved = book.isBookmarked;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _blocSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookData = widget.bookData;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.bg1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.texto3),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Detail Book",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.texto3,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: AppColor.texto3),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share icon pressed (visual only)'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: AppColor.bg2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => _showImagePopup(context, bookData['imagePath']),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  bookData['imagePath'] ?? 'https://via.placeholder.com/150',
                  height: MediaQuery.of(context).size.height * 0.29,
                  width: MediaQuery.of(context).size.width * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.bg1,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                border: Border.all(color: AppColor.bg2, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${(bookData['price'] ?? 0.0).toStringAsFixed(3)}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColor.coral,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            bookData['title'] ?? 'Unknown Title',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.texto3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: AppColor.coral,
                          ),
                          onPressed: () {
                            setState(() {
                              isSaved = !isSaved;
                            });
                            context.read<EbookBloc>().add(
                                  ToggleBookmark(bookId: widget.bookData['id']),
                                );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSaved
                                      ? 'Book added to saved list!'
                                      : 'Book removed from saved list!',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Text(
                      "by ${bookData['author'] ?? 'Unknown Author'}",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.texto2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.bg2,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InfoTile(
                            label: "Rating",
                            value: "${bookData['rating'] ?? '0.0'}",
                            labelColor: AppColor.texto2,
                            valueColor: AppColor.texto3,
                          ),
                          InfoTile(
                            label: "Pages",
                            value: "${bookData['pages'] ?? '0'}",
                            labelColor: AppColor.texto2,
                            valueColor: AppColor.texto3,
                          ),
                          InfoTile(
                            label: "Language",
                            value: bookData['language'] ?? 'Unknown',
                            labelColor: AppColor.texto2,
                            valueColor: AppColor.texto3,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.texto3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          bookData['description'] ??
                              'No description available.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: AppColor.texto2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColor.bg2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.bg1, width: 2),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "QTY",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: quantity > 1
                            ? () => setState(() => quantity--)
                            : null,
                      ),
                      Text(
                        "$quantity",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.coral,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColor.texto3,
                        onPressed: quantity < 5
                            ? () => setState(() => quantity++)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bg1,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 21,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCart(
                          book: EbookModel(
                            id: bookData['id'],
                            title: bookData['title'],
                            author: bookData['author'],
                            price: bookData['price'],
                            rating: bookData['rating'],
                            pages: bookData['pages'],
                            language: bookData['language'],
                            description: bookData['description'],
                            imagePath: bookData['imagePath'],
                            isBookmarked: isSaved,
                          ),
                          quantity: quantity,
                        ));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Book added to cart!"),
                      ),
                    );
                  },
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.texto2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePopup(BuildContext context, String? imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColor.bg1, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imagePath ?? 'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.20,
                  left: MediaQuery.of(context).size.width * 0.64,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.bg1, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close, color: AppColor.bg1),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: labelColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
