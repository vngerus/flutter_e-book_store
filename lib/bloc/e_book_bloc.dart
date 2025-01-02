import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'e_book_event.dart';
part 'e_book_state.dart';

class EBookBloc extends Bloc<EBookEvent, EBookState> {
  EBookBloc() : super(EBookInitial()) {
    on<LoadEBooks>((event, emit) async {
      emit(EBookLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        final books = ["Libro 1", "Libro 2", "Libro 3"];
        emit(EBookLoaded(books));
      } catch (e) {
        emit(const EBookError("No se pudieron cargar los libros"));
      }
    });
  }
}
