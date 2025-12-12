import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:moviebrowser/core/error/failures.dart';
import 'package:moviebrowser/features/movies/domain/entities/movie.dart';
import 'package:moviebrowser/features/movies/domain/usecases/search_movies.dart';
import 'package:moviebrowser/features/search/presentation/bloc/search_bloc.dart';
import 'package:moviebrowser/features/search/presentation/bloc/search_event.dart';
import 'package:moviebrowser/features/search/presentation/bloc/search_state.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchBloc(searchMovies: mockSearchMovies);
  });

  tearDown(() {
    searchBloc.close();
  });

  final tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      voteAverage: 8.5,
    ),
  ];

  test('initial state should be SearchInitial', () {
    expect(searchBloc.state, SearchInitial());
  });

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchLoaded] when SearchMovies is added successfully',
    build: () {
      when(mockSearchMovies(any)).thenAnswer((_) async => Right(tMovies));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchMoviesEvent('test')),
    expect: () => [
      SearchLoading(),
      SearchLoaded(movies: tMovies, query: 'test'),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchError] when SearchMovies fails',
    build: () {
      when(mockSearchMovies(any))
          .thenAnswer((_) async => const Left(ServerFailure('Error')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const SearchMoviesEvent('test')),
    expect: () => [
      SearchLoading(),
      const SearchError('Error'),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchInitial] when query is empty',
    build: () => searchBloc,
    act: (bloc) => bloc.add(const SearchMoviesEvent('')),
    expect: () => [SearchInitial()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchInitial] when ClearSearch is added',
    build: () => searchBloc,
    act: (bloc) => bloc.add(const ClearSearch()),
    expect: () => [SearchInitial()],
  );
}

