import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:flutter/services.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';

void main() {
  group('App smoke tests', () {
    setUp(() {
      rootBundle.clear();
      CartRepository.instance.clear();
    });
    testWidgets('App displays HomeView as home', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Southsea Cinema'), findsOneWidget);
    });

    testWidgets('Displays movie cards and booking buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text('Wicked'), findsOneWidget);
      expect(find.text('BOOK NOW'), findsWidgets);

      await tester.scrollUntilVisible(
        find.text('Everything Everywhere All at Once'),
        150,
      );

      expect(
        find.text('Everything Everywhere All at Once'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping BOOK NOW opens the selected movie',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final MovieCard firstCard =
          tester.widget<MovieCard>(find.byType(MovieCard).first);

      final selectedMovie = firstCard.movie;

      await tester.tap(
        find.descendant(
          of: find.byType(MovieCard).first,
          matching: find.text('BOOK NOW'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);

      final MovieListing listing =
          tester.widget<MovieListing>(find.byType(MovieListing));

      expect(listing.movie.id, selectedMovie.id);

      expect(
        find.text('${selectedMovie.title} (${selectedMovie.ageRating})'),
        findsOneWidget,
      );
    });

    testWidgets('Cannot add zero tickets to basket', (tester) async {
      final movie = MovieRepository().getMovies().first;

      await tester.pumpWidget(
        MaterialApp(
          home: MovieListing(movie: movie),
        ),
      );

      await tester.tap(find.text('ADD TO ORDER'));
      await tester.pump();

      expect(
        find.text('Please select at least 1 ticket'),
        findsOneWidget,
      );

      expect(CartRepository.instance.getItems(), isEmpty);
    });
  });
}
