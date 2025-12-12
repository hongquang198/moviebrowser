import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getCachedMovies();
  Future<void> cacheMovies(List<MovieModel> movies);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _cacheKey = 'cached_movies';
  static const String _cacheTimestampKey = 'cache_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 1);

  MovieLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<MovieModel>> getCachedMovies() async {
    final timestamp = sharedPreferences.getInt(_cacheTimestampKey);
    if (timestamp == null) {
      throw CacheException('No cached data available');
    }

    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > _cacheValidDuration.inMilliseconds) {
      throw CacheException('Cache expired');
    }

    final moviesJson = sharedPreferences.getStringList(_cacheKey);
    if (moviesJson == null) {
      throw CacheException('No cached movies found');
    }

    return moviesJson
        .map((json) => MovieModel.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> cacheMovies(List<MovieModel> movies) async {
    final moviesJson = movies.map((m) => jsonEncode(m.toJson())).toList();
    await sharedPreferences.setStringList(_cacheKey, moviesJson);
    await sharedPreferences.setInt(
        _cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
  }
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}

