import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movies_bloc.dart';
import '../bloc/movies_event.dart';
import '../bloc/movies_state.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../widgets/movie_grid_sliver.dart';
import '../widgets/movie_carousel.dart';
import 'movie_detail_page.dart';
import '../../../search/presentation/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(const LoadPopularMovies());
    context.read<FavoritesBloc>().add(const LoadFavorites());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadMoreMovies() {
    _currentPage++;
    context.read<MoviesBloc>().add(LoadMoreMovies(page: _currentPage));
  }

  void _navigateToMovieDetail(Movie movie, bool isFavorite) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(
          movie: movie,
          isFavorite: isFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Browser'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MoviesBloc, MoviesState>(
            listener: (context, state) {
              if (state is MoviesError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () async {
            _currentPage = 1;
            context.read<MoviesBloc>().add(const LoadPopularMovies());
            context.read<FavoritesBloc>().add(const LoadFavorites());
          },
          child: CustomScrollView(
            slivers: [
              BlocBuilder<MoviesBloc, MoviesState>(
                builder: (context, moviesState) {
                  if (moviesState is MoviesLoaded && moviesState.isOffline) {
                    return SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.orange[100],
                        child: Row(
                          children: [
                            Icon(Icons.wifi_off, color: Colors.orange[900]),
                            const SizedBox(width: 8),
                            Text(
                              'Offline mode - showing cached content',
                              style: TextStyle(color: Colors.orange[900]),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, favoritesState) {
                  if (favoritesState is FavoritesLoaded &&
                      favoritesState.favorites.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Your Favorites',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          MovieCarousel(
                            movies: favoritesState.favorites,
                            isFavorite: (movie) => true,
                            onMovieTap: (movie) {
                              _navigateToMovieDetail(movie, true);
                            },
                            onFavoriteToggle: (movie) {
                              context
                                  .read<FavoritesBloc>()
                                  .add(RemoveFavorite(movie.id));
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Popular Movies',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              BlocBuilder<MoviesBloc, MoviesState>(
                builder: (context, state) {
                  if (state is MoviesLoading && state is! MoviesLoaded) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is MoviesLoaded) {
                    return BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, favoritesState) {
                        List<Movie> favorites = [];
                        if (favoritesState is FavoritesLoaded) {
                          favorites = favoritesState.favorites;
                        }
                        return MovieGridSliver(
                          movies: state.movies,
                          isFavorite: (movie) =>
                              favorites.any((m) => m.id == movie.id),
                          onMovieTap: (movie) {
                            final isFav =
                                favorites.any((m) => m.id == movie.id);
                            _navigateToMovieDetail(movie, isFav);
                          },
                          onFavoriteToggle: (movie) {
                            final isFav =
                                favorites.any((m) => m.id == movie.id);
                            if (isFav) {
                              context
                                  .read<FavoritesBloc>()
                                  .add(RemoveFavorite(movie.id));
                            } else {
                              context
                                  .read<FavoritesBloc>()
                                  .add(AddFavorite(movie));
                            }
                          },
                          onLoadMore:
                              state.hasReachedMax ? null : _loadMoreMovies,
                        );
                      },
                    );
                  }

                  if (state is MoviesError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<MoviesBloc>().add(
                                    const LoadCachedMovies());
                              },
                              child: const Text('Load Cached Movies'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

