import 'package:flutter_test/flutter_test.dart';
import 'package:trending_movies/utils/json_parsing_utils.dart';

void main() {
  group('parseMovieDetail', () {
    /// Tests that a valid JSON string is correctly parsed into a [MovieDetailModel] object.
    test('parses movie detail JSON correctly', () {
      const responseBody =
          '{"title": "Test Movie", "overview": "Test Overview", "budget": 1000000, "revenue": 2000000}';
      final movieDetail = parseMovieDetail(responseBody);

      // Adjust expectations based on the actual properties of MovieDetailModel
      expect(movieDetail.overview, 'Test Overview');
      expect(movieDetail.budget, 1000000);
      expect(movieDetail.revenue, 2000000);
    });

    /// Tests that an invalid JSON string throws a [FormatException].
    test('throws FormatException on invalid JSON', () {
      const invalidResponseBody = '{invalid json}';

      expect(
          () => parseMovieDetail(invalidResponseBody), throwsFormatException);
    });
  });

  group('parseMovies', () {
    /// Tests that a valid JSON string is correctly parsed into a list of [MovieModel] objects.
    test('parses movies JSON correctly', () {
      const responseBody =
          '{"results": [{"id": 1, "title": "Test Movie 1", "poster_path": "/path1", "release_date": "2022-01-01"}, {"id": 2, "title": "Test Movie 2", "poster_path": "/path2", "release_date": "2022-01-02"}]}';
      final movies = parseMovies(responseBody);

      expect(movies.length, 2);
      expect(movies[0].id, 1);
      expect(movies[0].title, 'Test Movie 1');
      expect(movies[0].imageUrl, 'https://image.tmdb.org/t/p/w500/path1');
      expect(movies[0].releaseDate, '2022-01-01');
      expect(movies[1].id, 2);
      expect(movies[1].title, 'Test Movie 2');
      expect(movies[1].imageUrl, 'https://image.tmdb.org/t/p/w500/path2');
      expect(movies[1].releaseDate, '2022-01-02');
    });

    /// Tests that an empty `results` array in the JSON string returns an empty list.
    test('returns empty list on empty results', () {
      const emptyResponseBody = '{"results": []}';
      final movies = parseMovies(emptyResponseBody);

      expect(movies, isEmpty);
    });

    /// Tests that an invalid JSON string throws a [FormatException].
    test('throws FormatException on invalid JSON', () {
      const invalidResponseBody = '{invalid json}';

      expect(() => parseMovies(invalidResponseBody), throwsFormatException);
    });
  });
}
