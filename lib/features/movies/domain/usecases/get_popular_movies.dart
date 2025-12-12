import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetPopularMovies implements UseCase<List<Movie>, GetPopularMoviesParams> {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(GetPopularMoviesParams params) async {
    return await repository.getPopularMovies(page: params.page);
  }
}

class GetPopularMoviesParams extends Equatable {
  final int page;

  const GetPopularMoviesParams({this.page = 1});

  @override
  List<Object> get props => [page];
}

