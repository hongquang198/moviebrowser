import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getPopularMovies({int page = 1});
  Future<List<MovieModel>> searchMovies(String query, {int page = 1});
  Future<MovieModel> getMovieDetails(int movieId);
  Future<String?> getMovieVideoKey(int movieId);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;
  final String apiKey;
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  MovieRemoteDataSourceImpl({
    required this.client,
    required this.apiKey,
  });

  @override
  Future<List<MovieModel>> getPopularMovies({int page = 1}) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/movie/popular?language=en-US&page=$page'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw ServerException('Failed to load popular movies: $errorMessage');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) {
      return [];
    }
    
    final encodedQuery = Uri.encodeComponent(query.trim());
    final response = await client.get(
      Uri.parse(
          '$_baseUrl/search/movie?&query=$encodedQuery&page=$page'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List;
      return results.map((json) => MovieModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw ServerException('Failed to search movies: $errorMessage');
    }
  }

  @override
  Future<MovieModel> getMovieDetails(int movieId) async {
    // Use append_to_response to get videos in the same call for optimization
    final response = await client.get(
      Uri.parse('$_baseUrl/movie/$movieId?&append_to_response=videos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      
      // Extract video key if available
      String? videoKey;
      if (data.containsKey('videos') && data['videos'] != null) {
        final videos = data['videos'] as Map<String, dynamic>;
        final results = videos['results'] as List?;
        if (results != null && results.isNotEmpty) {
          final trailer = results.firstWhere(
            (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
            orElse: () => results.first,
          );
          videoKey = trailer['key'] as String?;
        }
      }
      
      // Create movie model with video key
      final movieData = Map<String, dynamic>.from(data);
      if (videoKey != null) {
        movieData['video_key'] = videoKey;
      }
      
      return MovieModel.fromJson(movieData);
    } else if (response.statusCode == 404) {
      throw ServerException('Movie not found');
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw ServerException('Failed to load movie details: $errorMessage');
    }
  }

  @override
  Future<String?> getMovieVideoKey(int movieId) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/movie/$movieId/videos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List?;
      if (results != null && results.isNotEmpty) {
        // Prefer official trailer, then trailer, then teaser, then any video
        final trailer = results.firstWhere(
          (video) => video['site'] == 'YouTube' && 
                     video['type'] == 'Trailer' && 
                     (video['official'] == true || video['official'] == null),
          orElse: () => results.firstWhere(
            (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
            orElse: () => results.firstWhere(
              (video) => video['site'] == 'YouTube' && video['type'] == 'Teaser',
              orElse: () => results.first,
            ),
          ),
        );
        return trailer['key'] as String?;
      }
    } else if (response.statusCode == 404) {
      return null; // Movie not found, return null instead of throwing
    }
    return null;
  }

  /// Extracts error message from TMDB API response
  String _extractErrorMessage(http.Response response) {
    try {
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data.containsKey('status_message')) {
        return data['status_message'] as String;
      }
    } catch (e) {
      // If parsing fails, return status code
    }
    
    // Return appropriate message based on status code
    switch (response.statusCode) {
      case 401:
        return 'Invalid API key. Please check your API key.';
      case 404:
        return 'Resource not found.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
      case 502:
      case 503:
        return 'TMDB server error. Please try again later.';
      default:
        return 'HTTP ${response.statusCode}';
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

