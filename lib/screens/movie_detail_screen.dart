import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/providers/movie_provider.dart';
import 'package:trending_movies/utils/format_utils.dart';

/// [MovieDetailScreen] displays detailed information about a selected movie.
/// It uses Riverpod for state management and fetching movie details.
class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({
    super.key,
    required this.movieId,
    required this.movie,
  });

  /// The ID of the movie to fetch details for.
  final int movieId;

  /// The [MovieModel] instance containing basic movie information.
  final MovieModel movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the movieDetailProvider to get the movie details asynchronously.
    final movieDetailAsyncValue = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display movie poster image with a hero animation.
            Hero(
              tag: movie.id,
              child: CachedNetworkImage(
                imageUrl: movie.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 300,
              ),
            ),
            const SizedBox(height: 12.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle different states of the movie detail fetch process.
                  movieDetailAsyncValue.when(
                    data: (providerMovies) {
                      // Display movie details when data is successfully fetched.
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${movie.releaseDate} - (${providerMovies.spokenLanguages.join(', ')})",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            providerMovies.overview,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12.0),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Budget: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: formatCurrency(providerMovies.budget),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Revenue: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color,
                                    fontSize: 18,
                                  ),
                                ),
                                TextSpan(
                                  text: formatCurrency(providerMovies.revenue),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    // Display a loading indicator while fetching data.
                    loading: () => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    // Display an error message if the fetch process fails.
                    error: (error, stack) => const Center(
                      child: Text('Error loading movie details'),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
