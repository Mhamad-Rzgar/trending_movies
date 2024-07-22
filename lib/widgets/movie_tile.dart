import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trending_movies/screens/movie_detail_screen.dart';
import '../models/movie_model.dart';

/// [MovieTile] is a stateless widget that represents a single movie item.
///
/// It displays the movie's poster image, title, and release year.
/// When tapped, it navigates to the movie detail screen.
class MovieTile extends StatelessWidget {
  /// The [MovieModel] instance representing the movie.
  final MovieModel movie;

  /// Constructor for creating a [MovieTile] instance.
  const MovieTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(
              movieId: movie.id,
              movie: movie,
            ),
          ),
        );
      },
      padding: EdgeInsets.zero,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 0,
        color: Colors.white,
        semanticContainer: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                // Use ID as a tag for simple hero animation
                tag: movie.id,
                child: SizedBox(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: movie.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                movie.title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Text(
                movie.releaseDate.split('-')[0],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
