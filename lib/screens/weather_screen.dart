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
    final alertAsyncValue = ref.watch(alertProvider(city));
    final forecastAsyncValue = ref.watch(forecastProvider(city));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hi, $userName!',
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Current Weather and Forecast
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: weatherAsyncValue.when(
                              data: (weather) => Card(
                                elevation: 6,
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Temperature: ${weather.temperature}°C',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Condition: ${weather.condition}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 12),
                                      Image.network(
                                        weather.iconUrl,
                                        height: 60,
                                        width: 60,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (error, stack) =>
                                  Center(child: Text('Error: $error')),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Forecast List
                          Expanded(
                            child: forecastAsyncValue.when(
                              data: (forecast) => Card(
                                elevation: 6,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: Colors.lightBlue[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '4-Hour Forecast',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...forecast.map((hour) => ListTile(
                                            leading: Image.network(
                                              'https:${hour['condition']['icon']}',
                                              height: 40,
                                              width: 40,
                                            ),
                                            title: Text(
                                              '${hour['time']}',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                            subtitle: Text(
                                              '${hour['temp_c']}°C, ${hour['condition']['text']}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (error, stack) =>
                                  Center(child: Text('Error: $error')),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Alerts Section
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Weather Alerts',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      alertAsyncValue.when(
                        data: (alerts) {
                          final alertList = alerts['alert'] as List<dynamic>;
                          if (alertList.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('No alerts available for $city.'),
                            );
                          }
                          return ListView.builder(
                            itemCount: alertList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final alert = alertList[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.lightBlue[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        alert['headline'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Severity: ${alert['severity']}'),
                                      Text('Event: ${alert['event']}'),
                                      const SizedBox(height: 8),
                                      Text('Description: ${alert['desc']}'),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (error, stack) =>
                            Center(child: Text('Error: $error')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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
