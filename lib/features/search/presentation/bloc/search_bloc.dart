import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/usecases/search_movies.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc({required this.searchMovies}) : super(SearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await searchMovies(SearchMoviesParams(query: event.query));

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (movies) => emit(SearchLoaded(movies: movies, query: event.query)),
    );
  }

  void _onClearSearch(
    ClearSearch event,
    Emitter<SearchState> emit,
  ) {
    emit(SearchInitial());
  }
}

