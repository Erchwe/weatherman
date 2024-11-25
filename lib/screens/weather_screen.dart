import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';

class WeatherScreen extends ConsumerWidget {
  final String userName;
  final String city;

  WeatherScreen({required this.userName, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider(city));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Icon(Icons.wb_sunny, size: 28, color: Colors.amberAccent),
            const SizedBox(width: 8),
            Text(
              'WeatherMan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
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
            // Greeting
            Center(
              child: Text(
                'Hi, $userName!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),

            // Weather Information
            weatherAsyncValue.when(
              data: (weather) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.lightBlue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${weather.location}, ${weather.country}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Temperature: ${weather.temperature}°C',
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                'Condition: ${weather.condition}',
                                style: TextStyle(fontSize: 18),
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
                    ),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),

            // Spacer
            Spacer(),

            // Button to Select Other Cities
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  _showCitySelectionDialog(context);
                },
                child: Text('Other Cities'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCitySelectionDialog(BuildContext context) {
    final List<String> cities = ['Jakarta', 'London', 'New York', 'Tokyo', 'Sydney'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select a City'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: cities
                  .map(
                    (city) => ListTile(
                      title: Text(city),
                      onTap: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherScreen(
                              userName: userName,
                              city: city,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
