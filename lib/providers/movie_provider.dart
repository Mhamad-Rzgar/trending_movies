import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/models/movie_detail_model.dart';
import 'package:trending_movies/api/api_client.dart';
import 'package:hive/hive.dart';
import 'package:trending_movies/utils/connectivity_util.dart';

final movieListProvider =
    StateNotifierProvider<MovieListNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return MovieListNotifier(ref);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

List<MovieModel> parseMovies(List<dynamic> moviesJson) {
  return moviesJson.map((movie) => MovieModel.fromJson(movie)).toList();
}

MovieDetailModel parseMovieDetail(Map<String, dynamic> json) {
  return MovieDetailModel.fromJson(json);
}

final connectivityService = ConnectivityService();

final movieDetailProvider =
    FutureProvider.family<MovieDetailModel, int>((ref, movieId) async {
  final apiClient = ref.read(apiClientProvider);

  if (await connectivityService.hasInternetConnection()) {
    return await apiClient.fetchMovieDetails(movieId);
  } else {
    var movieDetailBox = Hive.box<MovieDetailModel>('movieDetailBox');
    final cachedMovieDetail = movieDetailBox.get(movieId);
    if (cachedMovieDetail != null) {
      return cachedMovieDetail;
    } else {
      throw Exception('No cached data available');
    }
  }
});

class MovieListNotifier extends StateNotifier<AsyncValue<List<MovieModel>>> {
  MovieListNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  final Ref ref;
  int currentPage = 1;
  bool _isFetching = false;

  Future<void> fetchMovies({bool loadMore = false}) async {
    if (_isFetching) return;

    _isFetching = true;

    try {
      final apiClient = ref.read(apiClientProvider);
      List<MovieModel> movies;

      if (await connectivityService.hasInternetConnection()) {
        final fetchedMovies =
            await apiClient.fetchTrendingMovies(page: currentPage);
        movies =
            loadMore ? [...state.value ?? [], ...fetchedMovies] : fetchedMovies;

        // Save the fetched movies to Hive
        var movieBox = Hive.box<MovieModel>('movieBox');
        for (var movie in fetchedMovies) {
          movieBox.put(movie.id, movie);
        }

        if (loadMore) {
          currentPage++;
        }
      } else {
        var movieBox = Hive.box<MovieModel>('movieBox');
        movies = movieBox.values.toList();
      }

      state = AsyncValue.data(movies);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    } finally {
      _isFetching = false;
    }
  }
}
