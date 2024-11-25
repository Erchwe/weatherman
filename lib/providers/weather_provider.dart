import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';

final weatherProvider = FutureProvider.family<Weather, String>((ref, city) async {
  final weatherService = WeatherService();
  return await weatherService.fetchWeather(city);
});
