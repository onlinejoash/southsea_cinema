import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets('Cannot add zero tickets to basket', (
    WidgetTester tester,
  ) async {
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

  testWidgets('Selecting tickets adds an item and shows confirmation', (
    WidgetTester tester,
  ) async {
    final movie = MovieRepository().getMovies().first;

    await tester.pumpWidget(
      MaterialApp(
        home: MovieListing(movie: movie),
      ),
    );

    await tester.tap(find.byType(DropdownMenu<int>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('ADD TO ORDER'));
    await tester.pump();

    final items = CartRepository.instance.getItems();

    expect(items.length, 1);
    expect(items.first.movie.id, movie.id);
    expect(items.first.quantity, 2);
    expect(
      find.text('Confirmed! You have selected 2 tickets.'),
      findsOneWidget,
    );
  });

  testWidgets('Back button returns to the previous screen', (
    WidgetTester tester,
  ) async {
    final movie = MovieRepository().getMovies().first;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        MovieListing(movie: movie),
                  ),
                );
              },
              child: const Text('Open movie'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open movie'));
    await tester.pumpAndSettle();

    expect(find.byType(MovieListing), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Open movie'), findsOneWidget);
    expect(find.byType(MovieListing), findsNothing);
  });
}
