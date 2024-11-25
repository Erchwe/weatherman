import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart'; // Update with your actual path
import '../models/weather.dart'; // Update with your actual path

class WeatherScreen extends ConsumerWidget {
  final String city;

  WeatherScreen({required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsyncValue = ref.watch(weatherProvider(city));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Row(
          children: [
            Icon(Icons.wb_sunny, size: 28),
            SizedBox(width: 8),
            Text(
              'WeatherMan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [Icon(Icons.account_circle)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting message
            Text(
              'Hi, User!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.orange[800],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            // City Weather Cards
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4, // Number of cities
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.lightBlue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Display location (city, country)
                          Text(
                            'Jakarta, Indonesia', // Example city
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          SizedBox(height: 8),

                          // Display temperature
                          Text(
                            '27.2°C',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Display weather condition
                          Text(
                            'Partly cloudy', // Example condition
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueGrey,
                            ),
                          ),
                          SizedBox(height: 8),

                          // Display weather icon (replace with actual icon URL)
                          Image.network(
                            'https://openweathermap.org/img/wn/02d.png', // Example icon URL
                            height: 50,
                            width: 50,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Weather information for the selected city
            weatherAsyncValue.when(
              data: (weather) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'City: ${weather.location}, ${weather.country}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Temperature: ${weather.temperature}°C'),
                    Text('Condition: ${weather.condition}'),
                    Image.network(weather.iconUrl),
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),

            // Other Cities Button
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle action to search for other cities
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[300], // Use 'backgroundColor'
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Other Cities',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
