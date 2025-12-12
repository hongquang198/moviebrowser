import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadPopularMovies extends MoviesEvent {
  final int page;

  const LoadPopularMovies({this.page = 1});

  @override
  List<Object> get props => [page];
}

class LoadMoreMovies extends MoviesEvent {
  final int page;

  const LoadMoreMovies({required this.page});

  @override
  List<Object> get props => [page];
}

class LoadCachedMovies extends MoviesEvent {
  const LoadCachedMovies();
}

