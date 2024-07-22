import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:trending_movies/models/movie_detail_model.dart';
import 'package:trending_movies/models/movie_model.dart';
import 'package:trending_movies/screens/movies_list_screen.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  // Register adapters
  Hive.registerAdapter(MovieDetailModelAdapter());
  Hive.registerAdapter(MovieModelAdapter());

  // Open boxes
  await Hive.openBox<MovieModel>('movieBox');
  await Hive.openBox<MovieDetailModel>('movieDetailBox');

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

/// [MainApp] is the root widget of the application.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(),
      debugShowCheckedModeBanner: false,
      home: const MoviesListScreen(),
    );
  }

  /// Configures the theme for the application.
  ThemeData themeData() {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.blueAccent,
      ),
      scaffoldBackgroundColor: const Color(0xFFF2F2F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          fontSize: 16.0,
          color: Colors.black54,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
      ),
    );
  }
}
