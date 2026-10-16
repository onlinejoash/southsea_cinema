import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:southsea_cinema/views/movie_listing.dart';

void main() {
  group('App smoke tests', () {
    testWidgets('App displays HomeView as home', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Southsea Cinema'), findsOneWidget);
    });

    testWidgets('Displays movie cards and booking buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.text('Everything Everywhere All at Once'), findsOneWidget);
      expect(find.text('Wicked'), findsOneWidget);
      expect(find.text('BOOK NOW'), findsNWidgets(2));
    });

  
testWidgets('Tapping BOOK NOW opens the selected movie',
    (WidgetTester tester) async {
  await tester.pumpWidget(const SouthseaCinemaApp());

  await tester.tap(find.text('BOOK NOW').first);
  await tester.pumpAndSettle();

  expect(find.byType(MovieListing), findsOneWidget);
  expect(
    find.text('Everything Everywhere All at Once (15)'),
    findsOneWidget,
  );
  expect(find.text('Tickets (£7.50 each)'), findsOneWidget);


  
  await tester.tap(find.byType(DropdownMenu<int>));
  await tester.pumpAndSettle();

  await tester.tap(find.text('1').last);
  await tester.pumpAndSettle();

  await tester.tap(find.text('ADD TO ORDER'));
  await tester.pump();

  expect(
    find.text('Confirmed! You have selected 1 tickets.'),
    findsOneWidget,
  );

});




  });
}

