import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/main.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/movie_listing.dart';
import 'package:southsea_cinema/repositories/cart_repository.dart';
import 'package:flutter/services.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  testWidgets('Light and dark theme colors have readable contrast',
      (WidgetTester tester) async {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
    await tester.pumpWidget(const SouthseaCinemaApp());

    final MaterialApp app =
        tester.widget<MaterialApp>(find.byType(MaterialApp));
    final List<ThemeData> themes = [app.theme!, app.darkTheme!];

    for (final ThemeData theme in themes) {
      final ColorScheme colors = theme.colorScheme;

      double contrastRatio(Color foreground, Color background) {
        final double foregroundLuminance = foreground.computeLuminance();
        final double backgroundLuminance = background.computeLuminance();
        final double lighter = foregroundLuminance > backgroundLuminance
            ? foregroundLuminance
            : backgroundLuminance;
        final double darker = foregroundLuminance > backgroundLuminance
            ? backgroundLuminance
            : foregroundLuminance;
        return (lighter + 0.05) / (darker + 0.05);
      }

      expect(contrastRatio(colors.onSurface, colors.surface),
          greaterThanOrEqualTo(4.5));
      expect(
        contrastRatio(colors.onSurfaceVariant, colors.surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        contrastRatio(colors.onPrimary, colors.primary),
        greaterThanOrEqualTo(4.5),
      );
    }
  });

  group('App smoke tests', () {
    setUp(() {
      rootBundle.clear();
      CartRepository.instance.clear();

      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });
    testWidgets('App displays HomeView as home', (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());

      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Southsea Cinema'), findsOneWidget);
    });

    testWidgets('Displays movie cards and booking buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      expect(find.text('Wicked'), findsOneWidget);
      expect(find.text('BOOK NOW'), findsWidgets);

      await tester.scrollUntilVisible(
        find.text('Everything Everywhere All at Once'),
        150,
      );

      expect(
        find.text('Everything Everywhere All at Once'),
        findsOneWidget,
      );
    });

    testWidgets('Tapping BOOK NOW opens the selected movie',
        (WidgetTester tester) async {
      await tester.pumpWidget(const SouthseaCinemaApp());
      await tester.pumpAndSettle();

      final MovieCard firstCard =
          tester.widget<MovieCard>(find.byType(MovieCard).first);

      final selectedMovie = firstCard.movie;

      await tester.tap(
        find.descendant(
          of: find.byType(MovieCard).first,
          matching: find.text('BOOK NOW'),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(MovieListing), findsOneWidget);

      final MovieListing listing =
          tester.widget<MovieListing>(find.byType(MovieListing));

      expect(listing.movie.id, selectedMovie.id);

      expect(
        find.text('${selectedMovie.title} (${selectedMovie.ageRating})'),
        findsOneWidget,
      );
    });
  });
}
