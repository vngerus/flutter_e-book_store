import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/screen/home_screen.dart';
import 'package:flutter_ebook_store/screen/book_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Book Store',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/bookDetail': (context) {
          final book =
              ModalRoute.of(context)!.settings.arguments as Map<String, String>;
          return BookDetailScreen(
            title: book["title"]!,
            author: book["author"]!,
            imagePath: book["image"]!,
            price: 20.0,
            rating: 4.5,
            pages: 123,
            language: "ENG",
            description: "Descripción del libro aquí...",
          );
        },
      },
    );
  }
}
