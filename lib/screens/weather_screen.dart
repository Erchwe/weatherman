import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart'; // Import your provider

class WeatherScreen extends ConsumerWidget {
  final String userName; // Add userName parameter
  final String city; // Add city parameter

  WeatherScreen({required this.userName, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider(city)); // Use Riverpod provider

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Same color as LandingPage
        title: Row(
          children: [
            Icon(Icons.wb_sunny, size: 28, color: Colors.amberAccent), // Icon color
            const SizedBox(width: 8),
            Text(
              'WeatherMan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent, // Text color
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personalized greeting
            Center(
              child: Text(
                'Hi, $userName!',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple, // Same greeting color as LandingPage
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Weather Information
            weatherAsyncValue.when(
              data: (weather) {
                return Center(
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.lightBlue[50], // Light blue card background
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${weather.location}, ${weather.country}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Consistent text color
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Temperature: ${weather.temperature}°C',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87, // Slightly darker text
                            ),
                          ),
                          Text(
                            'Condition: ${weather.condition}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          Image.network(
                            weather.iconUrl,
                            height: 80,
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ],
        ),
      ),
    );
  }
}
