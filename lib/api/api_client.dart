import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:trending_movies/constants/constants.dart';
import 'package:trending_movies/constants/end_points.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/models/movie_detail_model.dart';

class ApiClient {
  //
  // IMPORTANT NOTE
  // choosing access token Authorization as RECOMMENDED by API provider instead of API_KEY.

  // API GET call for getting trending movies and return it
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
      List<MovieModel> movies = (json.decode(response.body)['results'] as List)
          .map((data) => MovieModel.fromJson(data))
          .toList();

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

  // getting movies detail by id of the specific movies.
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
          MovieDetailModel.fromJson(json.decode(response.body));

      var movieDetailBox = Hive.box<MovieDetailModel>('movieDetailBox');
      movieDetailBox.put(movieId, movieDetail);

      return movieDetail;
    } else {
      // if we face any issue during the API get request throwing an failed Exception.
      throw Exception('Failed to load movie details');
    }
  }
}
