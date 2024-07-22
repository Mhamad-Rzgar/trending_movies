// utils/json_parsing_utils.dart
import 'dart:convert';
import 'package:trending_movies/models/movie_detail_model.dart';
import 'package:trending_movies/models/movie_model.dart';

/// Parses the movie detail JSON response in a background isolate.
///
/// [responseBody] is the raw JSON response as a [String].
///
/// Returns a [MovieDetailModel] parsed from the JSON.
MovieDetailModel parseMovieDetail(String responseBody) {
  final parsed = json.decode(responseBody);
  return MovieDetailModel.fromJson(parsed);
}

/// Parses the movies JSON response in a background isolate.
///
/// [responseBody] is the raw JSON response as a [String].
///
/// Returns a list of [MovieModel] parsed from the JSON.
List<MovieModel> parseMovies(String responseBody) {
  final parsed = json.decode(responseBody)['results'] as List;
  return parsed.map<MovieModel>((data) => MovieModel.fromJson(data)).toList();
}
