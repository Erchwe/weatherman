import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/weather_screen.dart'; // Update with your actual path

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WeatherScreen(city: 'Jakarta'), // Pass the 'city' parameter here
    );
  }
}
