import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoriteToggle;
  final ScrollController? scrollController;
  final VoidCallback? onLoadMore;
  final bool Function(Movie)? isFavorite;

  const MovieGrid({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.onFavoriteToggle,
    this.scrollController,
    this.onLoadMore,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text('No movies found'),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

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
    );
  }
}

