import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('creates Movie instance with given properties', () {
      const movie = Movie(
        id: 'wicked',
        title: 'Wicked',
        synopsis: 'A young woman studying at Shiz University.',
        ageRating: 'PG',
        runtime: '2 hours 40 minutes',
        screeningTime: 'Wednesday 21st Oct 2026 19:00',
        ticketPrice: 7.50,
        imagePath: 'assets/images/wicked.jpg',
      );

      expect(movie.id, 'wicked');
      expect(movie.title, 'Wicked');
      expect(movie.synopsis, 'A young woman studying at Shiz University.');
      expect(movie.ageRating, 'PG');
      expect(movie.runtime, '2 hours 40 minutes');
      expect(movie.screeningTime, 'Wednesday 21st Oct 2026 19:00');
      expect(movie.ticketPrice, 7.50);
      expect(movie.imagePath, 'assets/images/wicked.jpg');
    });

    test('formattedPrice shows two decimal places', () {
      const wholePoundMovie = Movie(
        id: 'test1',
        title: 'Test Movie',
        synopsis: 'Test synopsis',
        ageRating: 'PG',
        runtime: '2 hours',
        screeningTime: '18:00',
        ticketPrice: 6.00,
        imagePath: 'assets/images/test.jpg',
      );

      const penceMovie = Movie(
        id: 'test2',
        title: 'Test Movie 2',
        synopsis: 'Test synopsis',
        ageRating: 'PG',
        runtime: '2 hours',
        screeningTime: '20:00',
        ticketPrice: 7.50,
        imagePath: 'assets/images/pencemovie.jpg',
      );

      expect(wholePoundMovie.formattedPrice, '£6.00');
      expect(penceMovie.formattedPrice, '£7.50');
    });
  });
}
