import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/weather_provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  final String userName;

  FavoritesScreen({required this.userName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteCities = ref.watch(favoriteCitiesProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Favorite Cities',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: favoriteCities.isEmpty
          ? const Center(
              child: Text(
                'No favorite cities yet!',
                style: TextStyle(fontSize: 18, color: Colors.deepPurple),
              ),
            )
          : ListView.builder(
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCities[index];
                final weatherAsyncValue = ref.watch(weatherProvider(city));
                final forecastAsyncValue = ref.watch(forecastProvider(city));
                final isFavorite = favoriteCities.contains(city);

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Cuaca Sekarang
                      weatherAsyncValue.when(
                        data: (weather) => Card(
                          elevation: 5,
                          color: Colors.lightBlue[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: Image.network(
                              weather.iconUrl,
                              height: 50,
                              width: 50,
                            ),
                            title: Text(
                              '${weather.location}, ${weather.country}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Temperature: ${weather.temperature}°C'),
                                Text('Condition: ${weather.condition}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                final notifier =
                                    ref.read(favoriteCitiesProvider.notifier);
                                if (isFavorite) {
                                  notifier.removeCity(city);
                                } else {
                                  notifier.addCity(city);
                                }
                              },
                            ),
                          ),
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const Text('Error loading weather'),
                      ),
                      const SizedBox(height: 8),

                      // Prediksi Cuaca 4 Jam ke Depan
                      forecastAsyncValue.when(
                        data: (forecast) {
                          final forecastFiltered = forecast.take(4).toList();
                          return Column(
                            children: forecastFiltered.map((hour) {
                              return Card(
                                elevation: 3,
                                color: Colors.white,
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
                            }).toList(),
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (_, __) =>
                            const Text('Error loading forecast data'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
