import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

class WeatherService {
  final String apiKey = 'a99a147b1bmsh5b91ab06988499dp11ad3bjsn9bb018a1d597';
  final String apiHost = 'weatherapi-com.p.rapidapi.com';

  Future<Weather> fetchWeather(String location) async {
    final response = await http.get(
      Uri.parse('https://$apiHost/current.json?q=$location'),
      headers: {
        'X-RapidAPI-Host': apiHost,
        'X-RapidAPI-Key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}