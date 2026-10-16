import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository unit tests', () {
    test('getMovies returns two movies', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      expect(movies.length, 2);
    });

    test('getMovies contains valid movies', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      final Movie firstMovie = movies[0];
      expect(firstMovie.id, 'everything-everywhere-all-at-once');
      expect(firstMovie.title, 'Everything Everywhere All at Once');
      expect(firstMovie.ticketPrice, 7.50);
      expect(firstMovie.imagePath, isNotEmpty);

      final Movie secondMovie = movies[1];
      expect(secondMovie.id, 'wicked');
      expect(secondMovie.title, 'Wicked');
      expect(secondMovie.ticketPrice, 7.50);
      expect(secondMovie.imagePath, isNotEmpty);
    });

    test('getMovieById returns matching movie when id exists', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('wicked');

      expect(movie, isNotNull);
      expect(movie?.title, 'Wicked');
      expect(movie?.ticketPrice, 7.50);
    });

    test('getMovieById returns null when id does not exist', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('non-existent');

      expect(movie, isNull);
    });
  });
}
