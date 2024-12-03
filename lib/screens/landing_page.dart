import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Ensure you have this package for animations
import 'weather_screen.dart';

class LandingPage extends StatelessWidget {
  final String userName;
  final String city;

  const LandingPage({super.key, required this.userName, required this.city});

  @override
  Widget build(BuildContext context) {
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
        child: PageView(
          children: [
            // First Slide: Welcome & Overview
            _buildTutorialPage(
              context,
              'Welcome to WeatherMan!',
              'Track your city’s weather with real-time data and forecasts.',
              'assets/weather_animation.json', // Replace with your animation path
            ),

            // Second Slide: Weather Dashboard
            _buildTutorialPage(
              context,
              'Your Weather Dashboard',
              'See the current weather details, such as temperature, humidity, and weather conditions.',
              'assets/dashboard_animation.json', // Replace with your animation path
            ),

            // Third Slide: Forecast
            _buildTutorialPage(
              context,
              'Weather Forecast',
              'Get a 4-hour weather forecast for your selected city.',
              'assets/forecast_animation.json', // Replace with your animation path
            ),

            // Fourth Slide: Alerts
            _buildTutorialPage(
              context,
              'Weather Alerts',
              'Stay up to date with any weather alerts or warnings in your area.',
              'assets/alerts_animation.json', // Replace with your animation path
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage(BuildContext context, String title,
      String description, String animationPath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lottie Animation
          Lottie.asset(
            animationPath,
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Button to continue to the main Weather screen
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              // Navigate to the main weather screen
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
            child: const Text("Start Using WeatherMan"),
          ),
        ],
      ),
    );
  }
}
