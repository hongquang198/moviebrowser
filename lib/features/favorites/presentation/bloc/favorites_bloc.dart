import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/is_favorite.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../../../core/usecases/usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final IsFavorite isFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.isFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<CheckIsFavorite>(_onCheckIsFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await getFavorites(const NoParams());

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addFavorite(AddFavoriteParams(movie: event.movie));

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) {
        // Reload favorites after adding
        add(const LoadFavorites());
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFavorite(RemoveFavoriteParams(movieId: event.movieId));

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) {
        // Reload favorites after removing
        add(const LoadFavorites());
      },
    );
  }

  Future<void> _onCheckIsFavorite(
    CheckIsFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await isFavorite(IsFavoriteParams(movieId: event.movieId));

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (isFav) => emit(IsFavoriteChecked(
        movieId: event.movieId,
        isFavorite: isFav,
      )),
    );
  }
}

