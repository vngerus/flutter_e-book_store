import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_state.dart';
import 'package:flutter_ebook_store/models/ebook_models.dart';
import 'package:flutter_ebook_store/widgets/authors_carrousel_widget.dart';
import 'package:flutter_ebook_store/widgets/book_carousel.dart';
import 'package:flutter_ebook_store/widgets/continue_reading_widget.dart';
import 'package:flutter_ebook_store/bloc/e_book_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_state.dart';
import 'package:flutter_ebook_store/screen/book_manager_screen.dart';
import 'package:flutter_ebook_store/screen/shopping_cart_screen.dart';
import 'package:flutter_ebook_store/widgets/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final Function(List<EbookModel>) onPurchaseComplete;

  const HomeScreen({super.key, required this.onPurchaseComplete});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<EbookModel> readingBooks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: DottedBackgroundPainter(),
          ),
          Column(
            children: [
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<EbookBloc, EbookState>(
                  builder: (context, state) {
                    if (state is EbookLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is EbookLoaded) {
                      final List<String> authors =
                          state.ebooks.map((e) => e.author).toSet().toList();
                      readingBooks = state.ebooks
                          .where((book) => book.progress > 0)
                          .toList();

                      return Column(
                        children: [
                          BookCarousel(books: state.ebooks),
                          const SizedBox(height: 16),
                          AuthorsCarrouselWidget(authors: authors),
                        ],
                      );
                    } else if (state is EbookError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return const Center(
                      child: Text("No books available."),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ContinueReadingWidget(
                readingBooks: readingBooks,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColor.bg2,
      leading: IconButton(
        icon: Image.asset(
          'assets/icons/settings.png',
          height: 24,
          width: 24,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BookManagerScreen(),
            ),
          );
        },
      ),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            int totalBooksCount = 0;

            if (state is CartLoaded) {
              totalBooksCount = state.cartItems.fold(
                0,
                (sum, item) => sum + item.quantity,
              );
            }

            return IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    'assets/icons/shopping-cart.png',
                    height: 24,
                    width: 24,
                  ),
                  if (totalBooksCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColor.coral,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            '$totalBooksCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShoppingCartScreen(
                      onPurchaseComplete: widget.onPurchaseComplete,
                    ),
                  ),
                );
              },
            );
          },
        ),
        CircleAvatar(
          backgroundColor: AppColor.bg1,
          child: const Text(
            "AS",
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.bg1, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.bg1, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColor.bg1, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

class DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.bg2
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
