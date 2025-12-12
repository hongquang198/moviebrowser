import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_cached_movies.dart';
import '../../../../core/usecases/usecase.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetPopularMovies getPopularMovies;
  final GetCachedMovies getCachedMovies;

  MoviesBloc({
    required this.getPopularMovies,
    required this.getCachedMovies,
  }) : super(MoviesInitial()) {
    on<LoadPopularMovies>(_onLoadPopularMovies);
    on<LoadMoreMovies>(_onLoadMoreMovies);
    on<LoadCachedMovies>(_onLoadCachedMovies);
  }

  Future<void> _onLoadPopularMovies(
    LoadPopularMovies event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());

    final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));

    result.fold(
      (failure) {
        // Try to load from cache on error
        add(const LoadCachedMovies());
      },
      (movies) {
        emit(MoviesLoaded(
          movies: movies,
          hasReachedMax: movies.isEmpty,
          isOffline: false,
        ));
      },
    );
  }

  Future<void> _onLoadMoreMovies(
    LoadMoreMovies event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      if (currentState.hasReachedMax) return;

      final result = await getPopularMovies(GetPopularMoviesParams(page: event.page));

      result.fold(
        (failure) => emit(MoviesError(failure.message)),
        (newMovies) {
          if (newMovies.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(currentState.copyWith(
              movies: [...currentState.movies, ...newMovies],
            ));
          }
        },
      );
    }
  }

  Future<void> _onLoadCachedMovies(
    LoadCachedMovies event,
    Emitter<MoviesState> emit,
  ) async {
    final result = await getCachedMovies(const NoParams());

    result.fold(
      (failure) => emit(MoviesError(failure.message)),
      (movies) {
        emit(MoviesLoaded(
          movies: movies,
          hasReachedMax: true,
          isOffline: true,
        ));
      },
    );
  }
}

