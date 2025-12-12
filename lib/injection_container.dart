import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Movies Feature
import 'features/movies/domain/repositories/movie_repository.dart';
import 'features/movies/domain/usecases/get_popular_movies.dart';
import 'features/movies/domain/usecases/search_movies.dart';
import 'features/movies/domain/usecases/get_cached_movies.dart';
import 'features/movies/data/datasources/movie_remote_data_source.dart';
import 'features/movies/data/datasources/movie_local_data_source.dart';
import 'features/movies/data/repositories/movie_repository_impl.dart';
import 'features/movies/presentation/bloc/movies_bloc.dart';

// Favorites Feature
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/get_favorites.dart';
import 'features/favorites/domain/usecases/add_favorite.dart';
import 'features/favorites/domain/usecases/remove_favorite.dart';
import 'features/favorites/domain/usecases/is_favorite.dart';
import 'features/favorites/data/datasources/favorites_local_data_source.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';

// Search Feature
import 'features/search/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());

  // Movies Feature - Data sources
  const String tmdbApiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiZmQ3ODZjNzY0ODYxMTcwZDQzZDNmZDExYmVhNWI2OCIsIm5iZiI6MTc2NTUwNTQ1NC4yMTI5OTk4LCJzdWIiOiI2OTNiNzlhZWY0Mzc1OTE1ODIwYzE2MGMiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.4JUUWnBFxUvBXs67mOcgGb7CWSvZJOeorH4O__i5K_4';
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl(), apiKey: tmdbApiKey),
  );
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Favorites Feature - Data sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Movies Feature - Repositories
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectivity: sl(),
    ),
  );

  // Favorites Feature - Repositories
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Movies Feature - Use cases
  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => SearchMovies(sl()));
  sl.registerLazySingleton(() => GetCachedMovies(sl()));

  // Favorites Feature - Use cases
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFavorite(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));

  // BLoC
  sl.registerFactory(
    () => MoviesBloc(
      getPopularMovies: sl(),
      getCachedMovies: sl(),
    ),
  );
  sl.registerFactory(
    () => SearchBloc(searchMovies: sl()),
  );
  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      addFavorite: sl(),
      removeFavorite: sl(),
      isFavorite: sl(),
    ),
  );
}
