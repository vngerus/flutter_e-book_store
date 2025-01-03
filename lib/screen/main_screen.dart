import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/bookmark_screen.dart';
import 'package:flutter_ebook_store/screen/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const HomeScreen(),
      BookmarkScreen(onBack: () => onItemTapped(0)),
    ]);
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Color _getBackgroundColor() {
    return selectedIndex == 0 ? Colors.teal : Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: _getBackgroundColor(),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: IndexedStack(
            index: selectedIndex,
            children: _pages,
          ),
          bottomNavigationBar: Container(
            height: 70,
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
                  icon: Icons.explore,
                  activeColor: Colors.orange,
                ),
                _customBottomMenuItem(
                  onPressed: () => onItemTapped(1),
                  isActive: selectedIndex == 1,
                  title: "Bookmark",
                  icon: Icons.bookmark_border,
                  activeColor: Colors.orange,
                ),
              ],
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
    required IconData icon,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: () => onPressed(),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
