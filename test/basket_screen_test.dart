
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:southsea_cinema/screens/basket_screen.dart';

const Movie testMovie = Movie(
  id: 'wicked',
  title: 'Wicked',
  synopsis: 'A musical fantasy film.',
  ageRating: 'PG',
  runtime: '160 minutes',
  screeningTime: '18:00',
  ticketPrice: 10.0,
  imagePath: 'assets/images/wicked.jpg',
);

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  testWidgets(
    'BasketScreen displays empty message when basket has no items',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: BasketScreen()),
      );

      expect(find.text('Your basket is empty'), findsOneWidget);
      expect(find.text('Checkout'), findsNothing);
    },
  );

  testWidgets(
    'BasketScreen renders tickets and removes item when delete pressed',
    (WidgetTester tester) async {
      const CartItem item = CartItem(
        movie: testMovie,
        quantity: 2,
      );

      CartRepository.instance.addItem(item);

      await tester.pumpWidget(
        const MaterialApp(home: BasketScreen()),
      );

      expect(find.text('Your basket'), findsOneWidget);
      expect(find.text('2 x Wicked'), findsOneWidget);
      expect(find.text('£20.00'), findsWidgets);
      expect(find.text('Checkout'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Your basket is empty'), findsOneWidget);
    },
  );
}
