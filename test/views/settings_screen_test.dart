import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:southsea_cinema/main.dart';
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
    expect(find.byType(Switch), findsNWidgets(2));
    expect(find.widgetWithText(SwitchListTile, 'Dark mode'), findsOneWidget);
    expect(find.text('Save Settings'), findsOneWidget);
  });

  testWidgets('Dark mode switch toggles its displayed state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SettingsScreen()),
    );

    final Finder darkModeSwitch = find.widgetWithText(
      SwitchListTile,
      'Dark mode',
    );

    expect(tester.widget<SwitchListTile>(darkModeSwitch).value, isTrue);

    await tester.tap(find.text('Dark mode'));
    await tester.pump();

    expect(tester.widget<SwitchListTile>(darkModeSwitch).value, isFalse);
  });

  testWidgets('Settings switch updates the application ThemeMode',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );

    final NavigatorState navigator =
        tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pushNamed('/settings');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('Dark mode preference persists after app restart',
      (WidgetTester tester) async {
    await tester.pumpWidget(const SouthseaCinemaApp());

    final NavigatorState navigator =
        tester.state<NavigatorState>(find.byType(Navigator).first);
    navigator.pushNamed('/settings');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark mode'));
    await tester.pumpAndSettle();

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    expect(await prefs.getBool(prefDarkMode), isFalse);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const SouthseaCinemaApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    final NavigatorState restartedNavigator =
        tester.state<NavigatorState>(find.byType(Navigator).first);
    restartedNavigator.pushNamed('/settings');
    await tester.pumpAndSettle();

    final SwitchListTile darkModeSwitch = tester.widget<SwitchListTile>(
      find.widgetWithText(SwitchListTile, 'Dark mode'),
    );
    expect(darkModeSwitch.value, isFalse);
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

    final Finder newsletterRow = find
        .ancestor(
          of: find.text('Receive news by email'),
          matching: find.byType(Row),
        )
        .first;
    final Finder switchFinder = find.descendant(
      of: newsletterRow,
      matching: find.byType(Switch),
    );

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
