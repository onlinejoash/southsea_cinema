
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/user_settings.dart';

void main() {
  test('UserSettings has correct default values', () {
    final UserSettings settings = UserSettings();

    expect(settings.name, isEmpty);
    expect(settings.address, isEmpty);
    expect(settings.email, isEmpty);
    expect(settings.receiveNewsletter, isFalse);
  });

  test('UserSettings stores supplied values', () {
    final UserSettings settings = UserSettings(
      name: 'Taylor Reed',
      address: '22 Guildhall Walk',
      email: 'taylor@example.com',
      receiveNewsletter: true,
    );

    expect(settings.name, 'Taylor Reed');
    expect(settings.address, '22 Guildhall Walk');
    expect(settings.email, 'taylor@example.com');
    expect(settings.receiveNewsletter, isTrue);
  });
}
