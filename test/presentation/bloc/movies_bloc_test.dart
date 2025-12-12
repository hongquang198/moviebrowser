import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:moviebrowser/core/error/failures.dart';
import 'package:moviebrowser/features/movies/domain/entities/movie.dart';
import 'package:moviebrowser/features/movies/domain/usecases/get_cached_movies.dart';
import 'package:moviebrowser/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:moviebrowser/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:moviebrowser/features/movies/presentation/bloc/movies_event.dart';
import 'package:moviebrowser/features/movies/presentation/bloc/movies_state.dart';

import 'movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies, GetCachedMovies])
void main() {
  late MoviesBloc moviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetCachedMovies mockGetCachedMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetCachedMovies = MockGetCachedMovies();
    moviesBloc = MoviesBloc(
      getPopularMovies: mockGetPopularMovies,
      getCachedMovies: mockGetCachedMovies,
    );
  });

  tearDown(() {
    moviesBloc.close();
  });

  final tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      voteAverage: 8.5,
    ),
  ];

  test('initial state should be MoviesInitial', () {
    expect(moviesBloc.state, MoviesInitial());
  });

  blocTest<MoviesBloc, MoviesState>(
    'emits [MoviesLoading, MoviesLoaded] when LoadPopularMovies is added successfully',
    build: () {
      when(mockGetPopularMovies(any))
          .thenAnswer((_) async => Right(tMovies));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(const LoadPopularMovies()),
    expect: () => [
      MoviesLoading(),
      MoviesLoaded(movies: tMovies, hasReachedMax: false, isOffline: false),
    ],
    verify: (_) {
      verify(mockGetPopularMovies(const GetPopularMoviesParams(page: 1)))
          .called(1);
    },
  );

  blocTest<MoviesBloc, MoviesState>(
    'emits [MoviesLoading, MoviesLoaded with offline=true] when LoadPopularMovies fails and cache succeeds',
    build: () {
      when(mockGetPopularMovies(any))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));
      when(mockGetCachedMovies(any)).thenAnswer((_) async => Right(tMovies));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(const LoadPopularMovies()),
    expect: () => [
      MoviesLoading(),
      MoviesLoaded(movies: tMovies, hasReachedMax: true, isOffline: true),
    ],
  );

  blocTest<MoviesBloc, MoviesState>(
    'emits [MoviesLoading, MoviesError] when both LoadPopularMovies and cache fail',
    build: () {
      when(mockGetPopularMovies(any))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));
      when(mockGetCachedMovies(any))
          .thenAnswer((_) async => const Left(CacheFailure('Cache error')));
      return moviesBloc;
    },
    act: (bloc) => bloc.add(const LoadPopularMovies()),
    expect: () => [
      MoviesLoading(),
      const MoviesError('Cache error'),
    ],
  );
}

