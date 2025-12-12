import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../movies/presentation/widgets/movie_grid.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_bar.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBarWidget(
              onSearch: (query) {
                context.read<SearchBloc>().add(SearchMoviesEvent(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is SearchLoaded) {
                  final favoritesState = context.watch<FavoritesBloc>().state;
                  List<Movie> favorites = [];
                  if (favoritesState is FavoritesLoaded) {
                    favorites = favoritesState.favorites;
                  }

                  return state.movies.isEmpty
                      ? const Center(child: Text('No movies found'))
                      : MovieGrid(
                          movies: state.movies,
                          isFavorite: (movie) =>
                              favorites.any((m) => m.id == movie.id),
                          onMovieTap: (movie) {
                            final isFav =
                                favorites.any((m) => m.id == movie.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(
                                  movie: movie,
                                  isFavorite: isFav,
                                ),
                              ),
                            );
                          },
                          onFavoriteToggle: (movie) {
                            final isFav =
                                favorites.any((m) => m.id == movie.id);
                            if (isFav) {
                              context
                                  .read<FavoritesBloc>()
                                  .add(RemoveFavoriteEvent(movie.id));
                            } else {
                              context
                                  .read<FavoritesBloc>()
                                  .add(AddFavoriteEvent(movie));
                            }
                          },
                        );
                }

                if (state is SearchError) {
                  return Center(child: Text(state.message));
                }

                return const Center(
                  child: Text('Start typing to search for movies'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

