import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/widgets/book_carousel.dart';
import 'package:flutter_ebook_store/widgets/continue_reading_widget.dart';
import 'package:flutter_ebook_store/bloc/e_book_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_state.dart';
import 'package:flutter_ebook_store/screen/book_manager_screen.dart';
import 'package:flutter_ebook_store/screen/shopping_cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
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
                      return BookCarousel(books: state.ebooks);
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
          const Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ContinueReadingWidget(),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200],
      leading: IconButton(
        icon: const Icon(Icons.grid_view, color: Colors.black),
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
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShoppingCartScreen(),
              ),
            );
          },
        ),
        const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
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
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
