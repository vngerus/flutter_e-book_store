part of 'e_book_bloc.dart';

sealed class EBookEvent extends Equatable {
  const EBookEvent();

  @override
  List<Object> get props => [];
}

final class LoadEBooks extends EBookEvent {}
