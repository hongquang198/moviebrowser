import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../movies/domain/entities/movie.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<Movie>>> getFavorites();
  Future<Either<Failure, void>> addFavorite(Movie movie);
  Future<Either<Failure, void>> removeFavorite(int movieId);
  Future<Either<Failure, bool>> isFavorite(int movieId);
}

