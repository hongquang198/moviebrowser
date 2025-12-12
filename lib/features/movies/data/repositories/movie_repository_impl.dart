import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../../../core/error/failures.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_local_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final Connectivity connectivity;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies({int page = 1}) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Try to get from cache
        try {
          final cachedMovies = await localDataSource.getCachedMovies();
          return Right(cachedMovies);
        } catch (e) {
          return const Left(NetworkFailure('No internet connection and no cached data available'));
        }
      }

      final movies = await remoteDataSource.getPopularMovies(page: page);
      // Cache the movies
      await localDataSource.cacheMovies(movies);
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query, {int page = 1}) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final movies = await remoteDataSource.searchMovies(query, page: page);
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(int movieId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final movie = await remoteDataSource.getMovieDetails(movieId);
      return Right(movie);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> getMovieVideoKey(int movieId) async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return const Left(NetworkFailure('No internet connection'));
      }

      final videoKey = await remoteDataSource.getMovieVideoKey(movieId);
      return Right(videoKey);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getCachedMovies() async {
    try {
      final cachedMovies = await localDataSource.getCachedMovies();
      return Right(cachedMovies);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheMovies(List<Movie> movies) async {
    try {
      final movieModels = movies.map((m) => m as MovieModel).toList();
      await localDataSource.cacheMovies(movieModels);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error: $e'));
    }
  }
}

