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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
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

                    // Current Weather
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Current Weather Info
                        Expanded(
                          child: weatherAsyncValue.when(
                            data: (weather) {
                              return Card(
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
                              );
                            },
                            loading: () =>
                                const Center(child: CircularProgressIndicator()),
                            error: (error, stack) => Center(child: Text('Error: $error')),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // 4-Hour Forecast
                        Expanded(
                          child: forecastAsyncValue.when(
                            data: (forecast) {
                              // Filter data 4 jam ke depan
                              final forecastFiltered = forecast.where((hour) {
                                final now = DateTime.now();
                                final forecastTime = DateTime.parse(hour['time']);
                                return forecastTime.isAfter(now) || forecastTime.isAtSameMomentAs(now);
                              }).take(4).toList();

                              if (forecastFiltered.isEmpty) {
                                return const Text('No forecast available for the next 6 hours.');
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: forecastFiltered.length,
                                itemBuilder: (context, index) {
                                  final hour = forecastFiltered[index];
                                  return Card(
                                    elevation: 3,
                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  color: Colors.lightBlue[50],
                                    child: ListTile(
                                      leading: Image.network(
                                        'https:${hour['condition']['icon']}',
                                        height: 40,
                                        width: 40,
                                      ),
                                      title: Text(
                                        '${hour['time']} - ${hour['condition']['text']}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        'Temperature: ${hour['temp_c']}°C, Wind: ${hour['wind_kph']} kph',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, stack) => Center(child: Text('Error: $error')),
                          ),

                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // alert
                    const Text(
                      'Weather Alerts',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    alertAsyncValue.when(
                      data: (alerts) {
                        final alertList = alerts['alert'] as List<dynamic>;

                        if (alertList.isEmpty) {
                          return Text('No alerts available for $city.');
                        }

                        // Filter alert kota yang dicari - gagal
                        final filteredAlerts = alertList.where((alert) {
                          final areas = alert['areas']?.toLowerCase() ?? '';
                          return areas.contains(city.toLowerCase());
                        }).toList();

                        if (filteredAlerts.isEmpty) {
                          return Text('No specific alerts for $city.');
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: filteredAlerts.map((alert) {
                            return Card(
                              elevation: 3,
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
                                    Text(
                                      'Description: ${alert['desc']}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Instruction: ${alert['instruction']}',
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Center(child: Text('Error: $error')),
                    ),

                  ],
                ),
              ),
            ),

            // other cities
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
                child: const Text('Other Cities'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // popup selection
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
