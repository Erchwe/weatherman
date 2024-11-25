import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService();
});

final weatherProvider = FutureProvider.family<Weather, String>((ref, location) async {
  final weatherService = ref.read(weatherServiceProvider);
  return weatherService.fetchWeather(location);
});