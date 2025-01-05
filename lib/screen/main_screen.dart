import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/bookmark_screen.dart';
import 'package:flutter_ebook_store/screen/home_screen.dart';
import 'package:flutter_ebook_store/screen/reading_screen.dart';
import 'package:flutter_ebook_store/widgets/app_colors.dart';
import '../models/ebook_models.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  List<EbookModel> _purchasedBooks = [];

  void _addPurchasedBooks(List<EbookModel> books) {
    setState(() {
      for (var book in books) {
        if (!_purchasedBooks
            .any((purchasedBook) => purchasedBook.id == book.id)) {
          _purchasedBooks.add(book);
        }
      }
    });
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: MediaQuery.of(context).size,
          painter: DottedBackgroundPainter(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: IndexedStack(
            index: selectedIndex,
            children: [
              HomeScreen(onPurchaseComplete: _addPurchasedBooks),
              ReadingScreen(
                purchasedBooks: _purchasedBooks,
                onBackToExplore: () => onItemTapped(0),
              ),
              BookmarkScreen(onBack: () => onItemTapped(0)),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Material(
            elevation: 8,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _customBottomMenuItem(
                    onPressed: () => onItemTapped(0),
                    isActive: selectedIndex == 0,
                    title: "Explore",
                    icon: selectedIndex == 0
                        ? Icons.explore
                        : Icons.explore_outlined,
                    activeColor: Colors.orange,
                  ),
                  _customBottomMenuItem(
                    onPressed: () => onItemTapped(1),
                    isActive: selectedIndex == 1,
                    title: "Reading",
                    iconPath: selectedIndex == 1
                        ? 'assets/icons/book-open-text.png'
                        : 'assets/icons/book-open.png',
                    activeColor: Colors.orange,
                  ),
                  _customBottomMenuItem(
                    onPressed: () => onItemTapped(2),
                    isActive: selectedIndex == 2,
                    title: "Bookmark",
                    icon: selectedIndex == 2
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _customBottomMenuItem({
    required Function() onPressed,
    required bool isActive,
    required String title,
    IconData? icon,
    String? iconPath,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (iconPath != null)
              Image.asset(
                iconPath,
                height: 24,
                width: 24,
                color: isActive ? activeColor : Colors.grey,
              )
            else
              Icon(
                icon,
                color: isActive ? activeColor : Colors.grey,
              ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? activeColor : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
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
