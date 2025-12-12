import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieGridSliver extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoriteToggle;
  final VoidCallback? onLoadMore;
  final bool Function(Movie)? isFavorite;

  const MovieGridSliver({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.onFavoriteToggle,
    this.onLoadMore,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Text('No movies found'),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final movie = movies[index];

            // Trigger load more when near the end
            if (index == movies.length - 3 && onLoadMore != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onLoadMore?.call();
              });
            }

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 300 + (index * 30)),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: child,
                  ),
                );
              },
              child: MovieCard(
                movie: movie,
                isFavorite: isFavorite?.call(movie) ?? false,
                onTap: () => onMovieTap?.call(movie),
                onFavoriteToggle: () => onFavoriteToggle?.call(movie),
              ),
            );
          },
          childCount: movies.length,
        ),
      ),
    );
  }
}

