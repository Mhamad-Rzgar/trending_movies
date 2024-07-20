import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trending_movies/api/api_client.dart';
import '../models/movie_model.dart';

final movieListProvider =
    StateNotifierProvider<MovieListNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return MovieListNotifier();
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
      final newMovie = await compute((e) {
        return newMovies.map((movie) => MovieModel.fromJson(movie));
      }, 'serialize');
      state = AsyncValue.data([...?state.value, ...newMovie]);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    } finally {
      _isLoading = false;
    }
  }
}
