import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:moviebrowser/core/error/failures.dart';
import 'package:moviebrowser/core/usecases/usecase.dart';
import 'package:moviebrowser/features/favorites/domain/usecases/get_favorites.dart';
import 'package:moviebrowser/features/favorites/domain/usecases/add_favorite.dart';
import 'package:moviebrowser/features/favorites/domain/usecases/remove_favorite.dart';
import 'package:moviebrowser/features/favorites/domain/usecases/is_favorite.dart';
import 'package:moviebrowser/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:moviebrowser/features/favorites/presentation/bloc/favorites_event.dart';
import 'package:moviebrowser/features/favorites/presentation/bloc/favorites_state.dart';
import 'package:moviebrowser/features/movies/domain/entities/movie.dart';

import 'favorites_bloc_test.mocks.dart';

@GenerateMocks([GetFavorites, AddFavorite, RemoveFavorite, IsFavorite])
void main() {
  late FavoritesBloc favoritesBloc;
  late MockGetFavorites mockGetFavorites;
  late MockAddFavorite mockAddFavorite;
  late MockRemoveFavorite mockRemoveFavorite;

  setUp(() {
    mockGetFavorites = MockGetFavorites();
    mockAddFavorite = MockAddFavorite();
    mockRemoveFavorite = MockRemoveFavorite();
    favoritesBloc = FavoritesBloc(
      getFavorites: mockGetFavorites,
      addFavorite: mockAddFavorite,
      removeFavorite: mockRemoveFavorite,
      isFavorite: MockIsFavorite(),
    );
  });

  tearDown(() {
    favoritesBloc.close();
  });

  final tMovie = const Movie(
    id: 1,
    title: 'Test Movie',
    overview: 'Test Overview',
    voteAverage: 8.5,
  );

  final tFavorites = [tMovie];

  test('initial state should be FavoritesInitial', () {
    expect(favoritesBloc.state, FavoritesInitial());
  });

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesLoading, FavoritesLoaded] when LoadFavorites is added successfully',
    build: () {
      when(mockGetFavorites(any)).thenAnswer((_) async => Right(tFavorites));
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(const LoadFavorites()),
    expect: () => [
      FavoritesLoading(),
      FavoritesLoaded(tFavorites),
    ],
    verify: (_) {
      verify(mockGetFavorites(const NoParams())).called(1);
    },
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'emits [FavoritesError] when LoadFavorites fails',
    build: () {
      when(mockGetFavorites(any))
          .thenAnswer((_) async => const Left(CacheFailure('Error')));
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(const LoadFavorites()),
    expect: () => [
      FavoritesLoading(),
      const FavoritesError('Error'),
    ],
  );

  blocTest<FavoritesBloc, FavoritesState>(
    'reloads favorites after AddFavorite succeeds',
    build: () {
      when(mockAddFavorite(any))
          .thenAnswer((_) async => const Right(null));
      when(mockGetFavorites(any)).thenAnswer((_) async => Right(tFavorites));
      return favoritesBloc;
    },
    act: (bloc) => bloc.add(AddFavoriteEvent(tMovie)),
    expect: () => [
      FavoritesLoading(),
      FavoritesLoaded(tFavorites),
    ],
  );
}

