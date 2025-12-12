import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  final String query;

  const SearchLoaded({
    required this.movies,
    required this.query,
  });

  @override
  List<Object> get props => [movies, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

