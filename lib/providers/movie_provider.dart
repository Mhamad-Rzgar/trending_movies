import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/models/movie_detail_model.dart';
import 'package:trending_movies/api/api_client.dart';
import 'package:hive/hive.dart';
import 'package:trending_movies/utils/connectivity_util.dart';

/// [movieListProvider] is a StateNotifierProvider that manages the state
/// of the list of movies, using [MovieListNotifier] to handle the logic.
final movieListProvider =
    StateNotifierProvider<MovieListNotifier, AsyncValue<List<MovieModel>>>(
        (ref) {
  return MovieListNotifier(ref);
});

/// [apiClientProvider] provides an instance of [ApiClient].
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

/// [connectivityService] is an instance of [ConnectivityService] to check internet connection status.
final connectivityService = ConnectivityService();

/// [movieDetailProvider] is a FutureProvider family that fetches movie details
/// based on the provided [movieId].
///
/// Returns a [Future] containing [MovieDetailModel].
/// If there is no internet connection, it retrieves data from the local Hive database.
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

/// [MovieListNotifier] is a StateNotifier that manages the state of a list of [MovieModel].
/// It fetches the movies either from the API or from the local Hive database based on the connectivity status.
class MovieListNotifier extends StateNotifier<AsyncValue<List<MovieModel>>> {
  MovieListNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  final Ref ref;
  int currentPage = 1;
  bool _isFetching = false;

  /// Fetches the list of trending movies.
  ///
  /// If [loadMore] is true, it fetches the next page of movies and appends them to the current list.
  /// Otherwise, it fetches the first page of movies and replaces the current list.
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
