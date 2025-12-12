import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../movies/data/models/movie_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<MovieModel>> getFavorites();
  Future<void> addFavorite(MovieModel movie);
  Future<void> removeFavorite(int movieId);
  Future<bool> isFavorite(int movieId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoritesKey = 'favorite_movies';

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<MovieModel>> getFavorites() async {
    final favoritesJson = sharedPreferences.getStringList(_favoritesKey);
    if (favoritesJson == null) return [];

    return favoritesJson
        .map((json) => MovieModel.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addFavorite(MovieModel movie) async {
    final favorites = await getFavorites();
    if (favorites.any((m) => m.id == movie.id)) {
      return; // Already favorited, silently return
    }

    favorites.add(movie);
    await _saveFavorites(favorites);
  }

  @override
  Future<void> removeFavorite(int movieId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((m) => m.id == movieId);
    await _saveFavorites(favorites);
  }

  @override
  Future<bool> isFavorite(int movieId) async {
    final favorites = await getFavorites();
    return favorites.any((m) => m.id == movieId);
  }

  Future<void> _saveFavorites(List<MovieModel> favorites) async {
    final favoritesJson = favorites.map((m) => jsonEncode(m.toJson())).toList();
    await sharedPreferences.setStringList(_favoritesKey, favoritesJson);
  }
}

