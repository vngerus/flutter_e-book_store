import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../models/ebook_models.dart';
import 'e_book_event.dart';
import 'e_book_state.dart';

class EbookBloc extends Bloc<EbookEvent, EbookState> {
  final Dio _dio = Dio();
  final List<EbookModel> _ebooks = [];

  EbookBloc() : super(EbookInitial()) {
    on<FetchEbooks>(_onFetchEbooks);
    on<AddEbook>(_onAddEbook);
    on<UpdateEbook>(_onUpdateEbook);
    on<DeleteEbook>(_onDeleteEbook);
    on<ToggleBookmark>(_onToggleBookmark);
  }

  Future<void> _onFetchEbooks(
      FetchEbooks event, Emitter<EbookState> emit) async {
    emit(EbookLoading());
    try {
      final response = await _dio.get(
        'https://ebook-e2025-default-rtdb.firebaseio.com/books.json',
      );
      if (response.data != null) {
        final booksData = (response.data as Map<String, dynamic>);
        _ebooks.clear();
        _ebooks.addAll(
          booksData.entries
              .map((entry) => EbookModel.fromJson(entry.key, entry.value))
              .toList(),
        );
        emit(EbookLoaded(List.from(_ebooks)));
      } else {
        emit(EbookError("No books found."));
      }
    } catch (e) {
      emit(EbookError("Failed to fetch books: $e"));
    }
  }

  Future<void> _onAddEbook(AddEbook event, Emitter<EbookState> emit) async {
    try {
      final newBook = {
        'title': event.title,
        'author': event.author,
        'price': event.price,
        'rating': event.rating,
        'pages': event.pages,
        'language': event.language,
        'description': event.description,
        'imagePath': event.imagePath,
        'isBookmarked': false,
      };
      await _dio.post(
        'https://ebook-e2025-default-rtdb.firebaseio.com/books.json',
        data: newBook,
      );

      add(FetchEbooks());
    } catch (e) {
      emit(EbookError("Failed to add book: $e"));
    }
  }

  Future<void> _onUpdateEbook(
      UpdateEbook event, Emitter<EbookState> emit) async {
    try {
      final updatedBook = {
        'title': event.title,
        'author': event.author,
        'price': event.price,
        'rating': event.rating,
        'pages': event.pages,
        'language': event.language,
        'description': event.description,
        'imagePath': event.imagePath,
      };

      await _dio.put(
        'https://ebook-e2025-default-rtdb.firebaseio.com/books/${event.id}.json',
        data: updatedBook,
      );

      final index = _ebooks.indexWhere((book) => book.id == event.id);
      if (index != -1) {
        _ebooks[index] = _ebooks[index].copyWith(
          title: event.title,
          author: event.author,
          price: event.price,
          rating: event.rating,
          pages: event.pages,
          language: event.language,
          description: event.description,
          imagePath: event.imagePath,
        );
        emit(EbookLoaded(List.from(_ebooks)));
      }
    } catch (e) {
      emit(EbookError("Failed to update book: $e"));
    }
  }

  Future<void> _onDeleteEbook(
      DeleteEbook event, Emitter<EbookState> emit) async {
    try {
      await _dio.delete(
        'https://ebook-e2025-default-rtdb.firebaseio.com/books/${event.id}.json',
      );

      _ebooks.removeWhere((book) => book.id == event.id);
      emit(EbookLoaded(List.from(_ebooks)));
    } catch (e) {
      emit(EbookError("Failed to delete book: $e"));
    }
  }

  void _onToggleBookmark(ToggleBookmark event, Emitter<EbookState> emit) async {
    try {
      final index = _ebooks.indexWhere((book) => book.id == event.bookId);
      if (index != -1) {
        final updatedBook = _ebooks[index].copyWith(
          isBookmarked: !_ebooks[index].isBookmarked,
        );
        _ebooks[index] = updatedBook;

        await _dio.put(
          'https://ebook-e2025-default-rtdb.firebaseio.com/books/${updatedBook.id}.json',
          data: updatedBook.toJson(),
        );

        emit(EbookLoaded(List.from(_ebooks)));
      }
    } catch (e) {
      emit(EbookError("Failed to toggle bookmark: $e"));
    }
  }
}
