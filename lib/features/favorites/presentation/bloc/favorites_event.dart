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

class AddFavoriteEvent extends FavoritesEvent {
  final Movie movie;

  const AddFavoriteEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int movieId;

  const RemoveFavoriteEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class CheckIsFavorite extends FavoritesEvent {
  final int movieId;

  const CheckIsFavorite(this.movieId);

  @override
  List<Object> get props => [movieId];
}

