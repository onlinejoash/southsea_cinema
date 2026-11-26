import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/views/home_view.dart';
import 'package:southsea_cinema/views/basket_view.dart';
import 'package:southsea_cinema/views/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isSupportedPlatform() {
  if (kIsWeb) {
    return false;
  }
  if (defaultTargetPlatform == TargetPlatform.android) {
    return true;
  }
  return false;
}

void main() {
  if (isSupportedPlatform()) {
    runApp(const SouthseaCinemaApp());
  } else {
    runApp(const UnsupportedPlatformApp());
  }
}

class UnsupportedPlatformApp extends StatelessWidget {
  const UnsupportedPlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'This app saves orders with SQLite and is set up to run on '
              'Android only. Stop the app and run it on an Android emulator '
              'or device instead.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class SouthseaCinemaApp extends StatefulWidget {
  const SouthseaCinemaApp({super.key});

  @override
  State<SouthseaCinemaApp> createState() => _SouthseaCinemaAppState();
}

class _SouthseaCinemaAppState extends State<SouthseaCinemaApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _themeModeChanged = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final bool? savedDarkMode = await prefs.getBool(prefDarkMode);

    if (!mounted || _themeModeChanged || savedDarkMode == null) {
      return;
    }

    setState(() {
      _themeMode = savedDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _setThemeMode(ThemeMode themeMode) async {
    setState(() {
      _themeModeChanged = true;
      _themeMode = themeMode;
    });

    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    await prefs.setBool(prefDarkMode, themeMode == ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData lightTheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: cinemaLightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cinemaBrand,
        brightness: Brightness.light,
      ).copyWith(
        primary: cinemaLightBrand,
        onPrimary: cinemaFontWhite,
        surface: cinemaLightSurface,
        onSurface: cinemaLightText,
        onSurfaceVariant: cinemaLightMuted,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cinemaLightSurface,
        iconTheme: IconThemeData(color: cinemaLightBrand),
        titleTextStyle: TextStyle(
          color: cinemaLightText,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
    );

    final ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: cinemaBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: cinemaBrand,
        brightness: Brightness.dark,
      ).copyWith(
        primary: cinemaBrand,
        onPrimary: cinemaBackground,
        surface: cinemaSurface,
        onSurface: cinemaFontWhite,
        onSurfaceVariant: cinemaFontMuted,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: cinemaSurface,
        iconTheme: IconThemeData(color: cinemaBrand),
        titleTextStyle: TextStyle(
          color: cinemaFontWhite,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
    );

    return MaterialApp(
      title: "Southsea Cinema & Arts Centre",
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        '/basket': (BuildContext context) {
          return const BasketScreen();
        },
        '/settings': (BuildContext context) {
          return SettingsScreen(
            themeMode: _themeMode,
            onThemeModeChanged: _setThemeMode,
          );
        },
      },
    );
  }
}
