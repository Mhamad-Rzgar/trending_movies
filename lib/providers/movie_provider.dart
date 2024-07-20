import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trending_movies/api/api_client.dart';
import 'package:trending_movies/models/movie_detail_model.dart';
import '../models/movie_model.dart';

final movieListProvider =
    StateNotifierProvider<MovieListNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return MovieListNotifier();
});

List<MovieModel> parseMovies(List<dynamic> moviesJson) {
  return moviesJson.map((movie) => MovieModel.fromJson(movie)).toList();
}

MovieDetailModel parseMovieDetail(Map<String, dynamic> json) {
  return MovieDetailModel.fromJson(json);
}

final movieDetailProvider =
    FutureProvider.family<MovieDetailModel?, int>((ref, movieId) async {
  try {
    final movieDetails = await ApiClient().fetchMovieDetails(movieId);

    // OPTIMIZATION Note: serialize it in a different thread of CPU
    return await compute(parseMovieDetail, movieDetails);
  } catch (error) {
    rethrow;
  }
});

class MovieListNotifier extends StateNotifier<AsyncValue<List<MovieModel>>> {
  MovieListNotifier() : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  int _currentPage = 1;
  bool _isLoading = false;

  Future<void> fetchMovies({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;

    if (loadMore) {
      _currentPage++;
    }

    try {
      final newMovies =
          await ApiClient().fetchTrendingMovies(page: _currentPage);

      // OPTIMIZATION Note: serialize it in a different thread of CPU
      final newMovieList = await compute(parseMovies, newMovies);

      state = AsyncValue.data([...?state.value, ...newMovieList]);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    } finally {
      _isLoading = false;
    }
  }
}
