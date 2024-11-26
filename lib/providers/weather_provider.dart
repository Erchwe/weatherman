import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';

final weatherProvider = FutureProvider.family<Weather, String>(
  (ref, city) async {
    final weatherService = WeatherService();
    return await weatherService.fetchWeather(city); // weather info
  },
);

final alertProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, city) async {
    final weatherService = WeatherService();
    return await weatherService.fetchWeatherAlerts(city); // alert
  },
);

final forecastProvider = FutureProvider.family<List<dynamic>, String>((ref, city) async {
  final weatherService = WeatherService();
  final forecastData = await weatherService.fetchForecast(city, 4);

  // Filter forecast untuk 6 jam ke depan
  final now = DateTime.now();
  final forecastFiltered = forecastData.where((hour) {
    final forecastTime = DateTime.parse(hour['time']);
    return forecastTime.isAfter(now) || forecastTime.isAtSameMomentAs(now);
  }).take(4).toList();

  return forecastFiltered;
});

