import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/landing_page.dart'; // Import LandingPage

void main() {
  runApp(
    ProviderScope( // Wrap with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(), // Set LandingPage as the starting point
    );
  }
}
