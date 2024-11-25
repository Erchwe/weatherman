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
        title: const Row(
          children: [
            Icon(Icons.wb_sunny, size: 28, color: Colors.amberAccent),
            SizedBox(width: 8),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // hi
              Center(
                child: Text(
                  'Hi, $userName!',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // card weather
              weatherAsyncValue.when(
                data: (weather) {
                  return Center(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.lightBlue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${weather.location}, ${weather.country}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Temperature: ${weather.temperature}°C',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Condition: ${weather.condition}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
              const Spacer(),

              // button bawah (other cities)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    _showCitySelectionDialog(context);
                  },
                  child: const Text('Other Cities'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // popup list
  // AI assisted
  void _showCitySelectionDialog(BuildContext context) {
    final List<String> cities = ['Jakarta', 'London', 'New York', 'Tokyo', 'Sydney'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a City'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: cities.map((city) {
              return ListTile(
                title: Text(city),
                onTap: () {
                  Navigator.pop(context);
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
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
