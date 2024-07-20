import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trending_movies/models/movie_model.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movie});

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Hero(
            tag: movie.id,
            child: CachedNetworkImage(imageUrl: movie.imageUrl),
          ),
          Text(movie.title),
          //
        ],
      ),
    );
  }
}
