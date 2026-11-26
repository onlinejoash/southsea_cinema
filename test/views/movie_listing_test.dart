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
}
