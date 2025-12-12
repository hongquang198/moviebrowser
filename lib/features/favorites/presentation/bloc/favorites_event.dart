import 'package:equatable/equatable.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddFavorite extends FavoritesEvent {
  final Movie movie;

  const AddFavorite(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFavorite extends FavoritesEvent {
  final int movieId;

  const RemoveFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class CheckIsFavorite extends FavoritesEvent {
  final int movieId;

  const CheckIsFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
}

