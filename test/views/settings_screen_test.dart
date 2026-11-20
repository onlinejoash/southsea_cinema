import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/settings_screen.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  testWidgets('SettingsScreen displays form fields and switch',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsScreen()),
    );

    expect(find.text('Patron Number'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Toggling switch and saving settings updates state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsScreen()),
    );

    await tester.pumpAndSettle();

    final Finder patronField = find.widgetWithText(TextField, 'Patron Number');

    final Finder addressField = find.widgetWithText(TextField, 'Address');

    final Finder emailField = find.widgetWithText(TextField, 'Email address');

    await tester.enterText(patronField, '12345');
    await tester.enterText(addressField, 'Guildhall Walk');
    await tester.enterText(emailField, 'taylor@example.com');

    final Finder switchFinder = find.byType(Switch);

    expect(tester.widget<Switch>(switchFinder).value, isFalse);

    await tester.tap(switchFinder);
    await tester.pump();

    expect(tester.widget<Switch>(switchFinder).value, isTrue);

    await tester.tap(find.text('Save Settings'));
    await tester.pumpAndSettle();

    expect(
      find.text('Settings saved for 12345'),
      findsOneWidget,
    );
  });
}
