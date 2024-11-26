import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = 'a99a147b1bmsh5b91ab06988499dp11ad3bjsn9bb018a1d597';
  final String apiHost = 'weatherapi-com.p.rapidapi.com';

  Future<Weather> fetchWeather(String query) async {
    final url = Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?q=$query');
    
    final response = await http.get(url, headers: {
      'x-rapidapi-host': 'weatherapi-com.p.rapidapi.com',
      'x-rapidapi-key': 'a99a147b1bmsh5b91ab06988499dp11ad3bjsn9bb018a1d597',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data); // cek model
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> fetchWeatherAlerts(String city) async {
    final url = Uri.parse(
        'https://weatherapi-com.p.rapidapi.com/alerts.json?q=$city');

    final response = await http.get(url, headers: {
      'X-RapidAPI-Key': 'a99a147b1bmsh5b91ab06988499dp11ad3bjsn9bb018a1d597', 
      'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['alerts'] ?? {'alert': []}; 
    } else {
      throw Exception('Failed to load weather alerts');
    }
  }  

Future<List<dynamic>> fetchForecast(String city, int hours) async {
  final response = await http.get(
    Uri.parse(
      'https://weatherapi-com.p.rapidapi.com/forecast.json?q=$city&hours=$hours',
    ),
    headers: {
      'x-rapidapi-host': apiHost,
      'x-rapidapi-key': apiKey,
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['forecast']['forecastday'][0]['hour'];
  } else {
    throw Exception('Failed to fetch forecast');
  }
}

}
