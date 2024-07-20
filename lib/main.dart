import 'package:flutter/material.dart';
import 'package:trending_movies/screens/movies_list_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MoviesListScreen(),
    );
  }
}
