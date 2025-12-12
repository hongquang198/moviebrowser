import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/movie.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;

  const MovieDetailPage({
    super.key,
    required this.movie,
    required this.isFavorite,
  });

  Future<void> _playVideo(String? videoKey) async {
    if (videoKey == null) return;
    final url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: movie.backdropUrl.isNotEmpty
                    ? movie.backdropUrl
                    : movie.posterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.movie, size: 50),
                ),
              ),
            ),
            actions: [
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  bool fav = isFavorite;
                  if (state is FavoritesLoaded) {
                    fav = state.favorites.any((m) => m.id == movie.id);
                  }

                  return IconButton(
                    icon: Icon(
                      fav ? Icons.favorite : Icons.favorite_border,
                      color: fav ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                      if (fav) {
                        context
                            .read<FavoritesBloc>()
                            .add(RemoveFavoriteEvent(movie.id));
                      } else {
                        context.read<FavoritesBloc>().add(AddFavoriteEvent(movie));
                      }
                    },
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (movie.voteAverage != null)
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 20),
                                      const SizedBox(width: 4),
                                      Text(
                                        movie.voteAverage!.toStringAsFixed(1),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                if (movie.voteAverage != null &&
                                    movie.year.isNotEmpty)
                                  const SizedBox(width: 16),
                                if (movie.year.isNotEmpty)
                                  Text(
                                    movie.year,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (movie.posterUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: movie.posterUrl,
                            width: 100,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (movie.overview != null && movie.overview!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overview',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.overview!,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (movie.videoKey != null)
                    ElevatedButton.icon(
                      onPressed: () => _playVideo(movie.videoKey),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Watch Trailer'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

