import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../../../../core/error/failures.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1});
  Future<Either<Failure, Movie>> getMovieDetails(int movieId);
  Future<Either<Failure, String?>> getMovieVideoKey(int movieId);
  Future<Either<Failure, List<Movie>>> getCachedMovies();
  Future<Either<Failure, void>> cacheMovies(List<Movie> movies);
}

