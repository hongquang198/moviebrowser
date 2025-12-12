import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';
import 'movie_card.dart';

class MovieCarousel extends StatelessWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;
  final Function(Movie)? onFavoriteToggle;
  final bool Function(Movie)? isFavorite;

  const MovieCarousel({
    super.key,
    required this.movies,
    this.onMovieTap,
    this.onFavoriteToggle,
    this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 300 + (index * 50)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: 180,
              child: MovieCard(
                movie: movie,
                isFavorite: isFavorite?.call(movie) ?? false,
                onTap: () => onMovieTap?.call(movie),
                onFavoriteToggle: () => onFavoriteToggle?.call(movie),
              ),
            ),
          );
        },
      ),
    );
  }
}

