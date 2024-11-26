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

final forecastProvider = FutureProvider.family<List<dynamic>, String>(
  (ref, city) async {
    final weatherService = WeatherService();
    return await weatherService.fetchForecast(city, 6); // forecast
  },
);
