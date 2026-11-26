import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfiNoIsolate;

    final Database database = await databaseFactoryFfiNoIsolate.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: CinemaDatabase.instance.createTables,
      ),
    );

    CinemaDatabase.instance.setDatabase(database);
  });

  tearDown(() async {
    await CinemaDatabase.instance.close();
  });

  Booking buildBooking(
    int bookingNumber,
    String summary,
    double total,
  ) {
    return Booking(
      bookingNumber: bookingNumber,
      summary: summary,
      total: total,
      date: '01/01/2026 10:00',
    );
  }

  test('insertBooking stores a booking and returns its id', () async {
    final int id = await CinemaDatabase.instance.insertBooking(
      buildBooking(1001, '1 x Wicked', 7.50),
    );

    expect(id, greaterThan(0));

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();

    expect(bookings.length, 1);
    expect(bookings[0].id, id);
    expect(bookings[0].summary, '1 x Wicked');
    expect(bookings[0].total, 7.50);
  });

  test('getNextBookingNumber increments the maximum', () async {
    expect(
      await CinemaDatabase.instance.getNextBookingNumber(),
      1001,
    );

    await CinemaDatabase.instance.insertBooking(
      buildBooking(1005, 'Booking', 7.50),
    );

    expect(
      await CinemaDatabase.instance.getNextBookingNumber(),
      1006,
    );
  });

  test('getAllBookings returns highest booking number first', () async {
    await CinemaDatabase.instance.insertBooking(
      buildBooking(1001, 'First', 5.00),
    );

    await CinemaDatabase.instance.insertBooking(
      buildBooking(1003, 'Third', 9.00),
    );

    await CinemaDatabase.instance.insertBooking(
      buildBooking(1002, 'Second', 7.00),
    );

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();

    expect(bookings.length, 3);
    expect(bookings[0].bookingNumber, 1003);
    expect(bookings[1].bookingNumber, 1002);
    expect(bookings[2].bookingNumber, 1001);
  });

  test('database getter returns the same cached database', () async {
    final Database database = await CinemaDatabase.instance.database;

    final Database cachedDatabase = await CinemaDatabase.instance.database;

    expect(cachedDatabase, same(database));
  });

  test('close clears the cached database', () async {
    final Database database = await CinemaDatabase.instance.database;

    await CinemaDatabase.instance.close();

    expect(database.isOpen, isFalse);

    await CinemaDatabase.instance.close();
  });

  test('uncached database initialises tables and sample bookings', () async {
    await CinemaDatabase.instance.close();
    CinemaDatabase.instance.setDatabase(null);

    final String folder = await getDatabasesPath();
    final String filePath = join(folder, 'cinema_data.db');
    await databaseFactoryFfiNoIsolate.deleteDatabase(filePath);

    final List<Booking> bookings =
        await CinemaDatabase.instance.getAllBookings();

    expect(bookings.length, 3);
    expect(bookings[0].bookingNumber, 1003);
    expect(bookings[0].summary, '2 x Wicked');
    expect(bookings[1].bookingNumber, 1002);
    expect(bookings[1].summary, '1 x Everything Everywhere All at Once');
    expect(bookings[2].bookingNumber, 1001);
    expect(bookings[2].summary, '1 x Wicked');

    await CinemaDatabase.instance.close();
  });
}
