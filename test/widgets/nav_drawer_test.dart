import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';

Widget buildTestApp() {
  return MaterialApp(
    home: Builder(
      builder: (BuildContext context) {
        return Scaffold(
          drawer: const NavDrawer(),
          body: Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  const Text('Home screen'),
                  TextButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Text('Open drawer'),
                  ),
                ],
              );
            },
          ),
        );
      },
    ),
    routes: {
      '/basket': (BuildContext context) => const Scaffold(
            body: Text('Basket screen'),
          ),
      '/settings': (BuildContext context) => const Scaffold(
            body: Text('Settings screen'),
          ),
    },
  );
}

void main() {
  testWidgets('NavDrawer close button closes the drawer',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
  });

  testWidgets('NavDrawer has the correct screen buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My Basket'), findsOneWidget);
    expect(find.text('My Settings'), findsOneWidget);
  });

  testWidgets('NavDrawer Home button opens the Home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();

    expect(find.text('Home screen'), findsOneWidget);
  });

  testWidgets('NavDrawer My Basket button opens the Basket screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Basket'));
    await tester.pumpAndSettle();

    expect(find.text('Basket screen'), findsOneWidget);
  });

  testWidgets('NavDrawer My Settings button opens the Settings screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.tap(find.text('Open drawer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('My Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings screen'), findsOneWidget);
  });
}
