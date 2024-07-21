import 'package:hive/hive.dart';
import 'package:trending_movies/constants/end_points.dart';
import 'movie_detail_model.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 1)
class MovieModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String releaseDate;

  @HiveField(4)
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
