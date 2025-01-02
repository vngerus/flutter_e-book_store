import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../models/ebook_models.dart';
import 'e_book_event.dart';
import 'e_book_state.dart';

class EbookBloc extends Bloc<EbookEvent, EbookState> {
  final Dio _dio = Dio();

  EbookBloc() : super(EbookInitial()) {
    on<FetchEbooks>((event, emit) async {
      emit(EbookLoading());
      try {
        final response = await _dio.get(
          'https://ebook-e2025-default-rtdb.firebaseio.com/books.json',
        );
        if (response.data != null) {
          final booksData = (response.data as Map<String, dynamic>);
          final ebooks = booksData.entries
              .map((entry) => EbookModel.fromJson(entry.key, entry.value))
              .toList();
          emit(EbookLoaded(ebooks));
        } else {
          emit(EbookError("No books found."));
        }
      } catch (e) {
        emit(EbookError("Failed to fetch books: $e"));
      }
    });
  }
}
