import 'package:trending_movies/constants/end_points.dart';

import 'movie_detail_model.dart';

class MovieModel {
  final int id;
  final String title;
  final String imageUrl;
  final String releaseDate;
  // Separate MovieDetailModel retrieved from a different API call to avoid numerous nullable fields.
  final MovieDetailModel? detail;

  MovieModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    this.detail,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      imageUrl: EndPoints.imageBaseUrl + json['poster_path'],
      releaseDate: json['release_date'] ?? 'Unknown',
      detail: json['detail'] == null
          ? null
          : MovieDetailModel.fromJson(json['detail']),
    );
  }
}
