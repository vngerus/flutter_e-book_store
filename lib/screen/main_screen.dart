import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(), // Pantalla principal
    Center(child: Text("Reading Screen")), // Pantalla de "Reading"
    Center(child: Text("Bookmark Screen")), // Pantalla de "Bookmark"
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _customBottomMenuItem(
              onTap: () => onItemTapped(0),
              isActive: selectedIndex == 0,
              title: "Explore",
              icon: Icons.explore,
              activeColor: Colors.orange,
            ),
            _customBottomMenuItem(
              onTap: () => onItemTapped(1),
              isActive: selectedIndex == 1,
              title: "Reading",
              icon: Icons.menu_book,
              activeColor: Colors.orange,
            ),
            _customBottomMenuItem(
              onTap: () => onItemTapped(2),
              isActive: selectedIndex == 2,
              title: "Bookmark",
              icon: Icons.bookmark_border,
              activeColor: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _customBottomMenuItem({
    required Function() onTap,
    required bool isActive,
    required String title,
    required IconData icon,
    required Color activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }
}
