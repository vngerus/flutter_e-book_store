import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_bloc.dart';
import 'package:flutter_ebook_store/bloc/e_book_event.dart';
import 'package:flutter_ebook_store/bloc/cart_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_event.dart';
import 'package:flutter_ebook_store/screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EbookBloc>(
          create: (_) => EbookBloc()..add(FetchEbooks()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc()..add(LoadCart()),
        ),
      ],
      child: MaterialApp(
        title: 'E-Book Store',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
