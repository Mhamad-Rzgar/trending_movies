import 'package:hive/hive.dart';
import 'package:trending_movies/constants/end_points.dart';
import 'movie_detail_model.dart';

part 'movie_model.g.dart';

/// [MovieModel] represents a movie with basic information and an optional detailed information.
///
/// This model is used to store movie data in Hive for offline access.
@HiveType(typeId: 1)
class MovieModel {
  /// Unique identifier for the movie.
  @HiveField(0)
  final int id;

  /// Title of the movie.
  @HiveField(1)
  final String title;

  /// URL of the movie's poster image.
  @HiveField(2)
  final String imageUrl;

  /// Release date of the movie.
  @HiveField(3)
  final String releaseDate;

  /// Detailed information about the movie, retrieved from a different API call.
  /// Separate MovieDetailModel retrieved from a different API call to avoid numerous nullable fields.
  @HiveField(4)
  final MovieDetailModel? detail;

  /// Constructor for creating a [MovieModel] instance.
  MovieModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.releaseDate,
    this.detail,
  });

  /// Factory constructor for creating a [MovieModel] instance from a JSON map.
  ///
  /// Parses the JSON to extract movie details including the poster image URL and release date.
  /// Associates detailed information if available.
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
