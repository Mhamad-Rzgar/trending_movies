import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trending_movies/constants/constants.test.dart';
import 'package:trending_movies/constants/end_points.dart';

class ApiClient {
  //
  // IMPORTANT NOTE
  // choosing access token Authorization as RECOMMENDED by API provider instead of API_KEY.

  // API GET call for getting trending movies and return it
  Future<List<dynamic>> fetchTrendingMovies({int page = 1}) async {
    var response = await http.get(
      Uri.parse(
          '${EndPoints.apiBaseUrl}/discover/movie?sort_by=popularity.desc&include_adult=false&page=$page'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.accessToken}'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      // if we face any issue during the API get request throwing an failed Exception.
      throw Exception('Failed to load movies');
    }
  }

  // getting movies detail by id of the specific movies.
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    var response = await http.get(
      Uri.parse('${EndPoints.apiBaseUrl}/movie/$movieId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppConstants.accessToken}'
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // if we face any issue during the API get request throwing an failed Exception.
      throw Exception('Failed to load movie details');
    }
  }
}
