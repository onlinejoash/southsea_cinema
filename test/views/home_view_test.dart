import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/views/home_view.dart';

void main() {
  testWidgets('HomeView displays a loading indicator while movies load',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeView(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomeView displays the app bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeView(),
      ),
    );

    expect(find.text('Southsea Cinema'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
