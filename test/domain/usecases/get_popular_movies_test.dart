import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:moviebrowser/core/error/failures.dart';
import 'package:moviebrowser/features/movies/domain/entities/movie.dart';
import 'package:moviebrowser/features/movies/domain/repositories/movie_repository.dart';
import 'package:moviebrowser/features/movies/domain/usecases/get_popular_movies.dart';

import 'get_popular_movies_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRepository);
  });

  final tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      voteAverage: 8.5,
    ),
  ];

  test('should get popular movies from the repository', () async {
    // arrange
    when(mockMovieRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => Right(tMovies));

    // act
    final result = await usecase(const GetPopularMoviesParams(page: 1));

    // assert
    expect(result, Right(tMovies));
    verify(mockMovieRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(mockMovieRepository.getPopularMovies(page: 1))
        .thenAnswer((_) async => const Left(ServerFailure('Server error')));

    // act
    final result = await usecase(const GetPopularMoviesParams(page: 1));

    // assert
    expect(result, const Left(ServerFailure('Server error')));
    verify(mockMovieRepository.getPopularMovies(page: 1));
    verifyNoMoreInteractions(mockMovieRepository);
  });
}

