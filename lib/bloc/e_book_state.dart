part of 'e_book_bloc.dart';

sealed class EBookState extends Equatable {
  const EBookState();

  @override
  List<Object> get props => [];
}

final class EBookInitial extends EBookState {}

final class EBookLoading extends EBookState {}

final class EBookLoaded extends EBookState {
  final List<String> books;
  const EBookLoaded(this.books);

  @override
  List<Object> get props => [books];
}

final class EBookError extends EBookState {
  final String message;
  const EBookError(this.message);

  @override
  List<Object> get props => [message];
}
