import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Movie> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class IsFavoriteChecked extends FavoritesState {
  final int movieId;
  final bool isFavorite;

  const IsFavoriteChecked({
    required this.movieId,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [movieId, isFavorite];
}

