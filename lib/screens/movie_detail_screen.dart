import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/providers/movie_provider.dart';

class MovieDetailScreen extends ConsumerWidget {
  const MovieDetailScreen({
    super.key,
    required this.movieId,
    required this.movie,
  });

  final int movieId;
  final MovieModel movie;

  String formatCurrency(int? amount) {
    final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
    return amount != null ? formatter.format(amount) : 'N/A';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  movieDetailAsyncValue.when(
                    data: (providerMovies) {
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
                    loading: () => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
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
