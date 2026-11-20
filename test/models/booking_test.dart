import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/booking.dart';

void main() {
  const Booking booking = Booking(
    bookingNumber: 1004,
    summary: '2 x Wicked',
    total: 15.00,
    date: '20/11/2026 10:00',
  );

  test('New bookings omit database ids and convert to map', () {
    expect(booking.id, isNull);

    expect(booking.toMap(), <String, Object?>{
      'booking_number': 1004,
      'summary': '2 x Wicked',
      'total': 15.00,
      'date': '20/11/2026 10:00',
    });
  });

  test('A database map converts back into a booking', () {
    final Map<String, Object?> row = <String, Object?>{
      'id': 7,
      'booking_number': 1010,
      'summary': '1 x Wicked',
      'total': 7.50,
      'date': '20/11/2026 11:00',
    };

    final Booking restored = Booking.fromMap(row);

    expect(restored.id, 7);
    expect(restored.bookingNumber, 1010);
    expect(restored.summary, '1 x Wicked');
    expect(restored.total, 7.50);
    expect(restored.date, '20/11/2026 11:00');
    expect(restored.toMap(), row);
  });

  test('Whole-number SQLite totals become doubles', () {
    final Map<String, Object?> row = booking.toMap();
    row['total'] = 15;

    final Booking restored = Booking.fromMap(row);

    expect(restored.total, 15.0);
    expect(restored.total, isA<double>());
  });
}
