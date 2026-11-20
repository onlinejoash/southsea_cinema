import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/cart_item.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';

const Movie testMovie1 = Movie(
  id: 'wicked',
  title: 'Wicked',
  synopsis:
      'Elphaba, a young woman ridiculed for her green skin, and Galinda, a popular girl, become friends at Shiz University in the Land of Oz. After an encounter with the Wonderful Wizard of Oz, their friendship reaches a crossroads.',
  ageRating: 'PG',
  runtime: '160 minutes',
  screeningTime: '18:00',
  ticketPrice: 10.0,
  imagePath: 'assets/images/wicked.jpg',
);

const Movie testMovie2 = Movie(
  id: 'everything-everywhere-all-at-once',
  title: 'Everything Everywhere All at Once',
  synopsis: 'A science fiction adventure.',
  ageRating: '15',
  runtime: '139 minutes',
  screeningTime: '20:00',
  ticketPrice: 6.0,
  imagePath: 'assets/images/everything-everywhere.jpg',
);

void main() {
  setUp(() {
    CartRepository.instance.clear();
  });

  group('CartRepository tests', () {
    test('starts with empty basket and zero totals', () {
      final CartRepository cart = CartRepository.instance;

      expect(cart.getItems().length, 0);
      expect(cart.getTotalItems(), 0);
      expect(cart.totalItemCount, 0);
      expect(cart.getSubtotal(), 0.0);
      expect(cart.getTotalDue(), 0.0);
    });

    test('adds items and calculates subtotal correctly', () {
      final CartRepository cart = CartRepository.instance;

      const CartItem item1 = CartItem(
        movie: testMovie1,
        quantity: 2,
      );

      const CartItem item2 = CartItem(
        movie: testMovie2,
        quantity: 1,
      );

      cart.addItem(item1);
      cart.addItem(item2);

      expect(cart.getItems().length, 2);
      expect(cart.getTotalItems(), 3);
      expect(cart.totalItemCount, 3);
      expect(cart.getSubtotal(), 26.0);
      expect(cart.getTotalDue(), 26.0);
    });

    test('removes items correctly', () {
      final CartRepository cart = CartRepository.instance;

      const CartItem item = CartItem(
        movie: testMovie1,
        quantity: 1,
      );

      cart.addItem(item);
      expect(cart.getItems().length, 1);

      cart.removeItem(0);

      expect(cart.getItems().length, 0);
      expect(cart.getTotalDue(), 0.0);
    });
  });
}
