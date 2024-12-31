import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/widgets/book_carousel.dart';
import 'package:flutter_ebook_store/widgets/continue_reading_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: BookCarousel(),
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

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[200],
      leading: IconButton(
        icon: const Icon(Icons.grid_view, color: Colors.black),
        onPressed: () {},
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {},
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
