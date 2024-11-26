class Weather {
  final String location;
  final String country;
  final double temperature;
  final String condition;
  final String iconUrl;

  Weather({
    required this.location,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['location']['name'],
      country: json['location']['country'],
      temperature: json['current']['temp_c'].toDouble(),
      condition: json['current']['condition']['text'],
      iconUrl: 'https:${json['current']['condition']['icon']}',
    );
  }
}
