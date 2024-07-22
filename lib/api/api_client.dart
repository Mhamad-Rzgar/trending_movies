import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:trending_movies/constants/constants.dart';
import 'package:trending_movies/constants/end_points.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/models/movie_detail_model.dart';

/// [ApiClient] handles API interactions for fetching trending movies
/// and movie details.
class ApiClient {
  /// Note: Using access token for Authorization as recommended by the API provider instead of API_KEY.

  /// Fetches a list of trending movies from the API.
  ///
  /// [page] specifies the page number for pagination. Defaults to 1.
  ///
  /// Returns a [Future] containing a list of [MovieModel].
  ///
  /// Throws an [Exception] if the API call fails.
  Future<List<MovieModel>> fetchTrendingMovies({int page = 1}) async {
    var response = await http.get(
      Uri.parse(
          '${EndPoints.apiBaseUrl}/discover/movie?sort_by=popularity.desc&include_adult=false&page=$page'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.accessToken}'
      },
    );

    if (response.statusCode == 200) {
      // Step 2: Use compute to run the parsing in the background
      List<MovieModel> movies = await compute(parseMovies, response.body);

      var movieBox = Hive.box<MovieModel>('movieBox');
      for (var movie in movies) {
        movieBox.put(movie.id, movie);
      }

      return movies;
    } else {
      // if we face any issue during the API get request throwing an failed Exception.
      throw Exception('Failed to load movies');
    }
  }

  /// Fetches the details of a specific movie by its [movieId].
  ///
  /// Returns a [Future] containing a [MovieDetailModel].
  ///
  /// Throws an [Exception] if the API call fails.
  Future<MovieDetailModel> fetchMovieDetails(int movieId) async {
    var response = await http.get(
      Uri.parse('${EndPoints.apiBaseUrl}/movie/$movieId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.accessToken}'
      },
    );

    if (response.statusCode == 200) {
      MovieDetailModel movieDetail =
          await compute(parseMovieDetail, response.body);

      var movieDetailBox = Hive.box<MovieDetailModel>('movieDetailBox');
      movieDetailBox.put(movieId, movieDetail);

      return movieDetail;
    } else {
      // if we face any issue during the API get request throwing an failed Exception.
      throw Exception('Failed to load movie details');
    }
  }

  MovieDetailModel parseMovieDetail(String responseBody) {
    final parsed = json.decode(responseBody);
    return MovieDetailModel.fromJson(parsed);
  }

  List<MovieModel> parseMovies(String responseBody) {
    final parsed = json.decode(responseBody)['results'] as List;
    return parsed.map<MovieModel>((data) => MovieModel.fromJson(data)).toList();
  }
}
