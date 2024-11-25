import 'package:flutter/material.dart';
import 'weather_screen.dart'; // Import WeatherScreen

class LandingPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple, // Changed AppBar color
        title: Row(
          children: [
            Icon(Icons.wb_sunny, size: 28, color: Colors.amberAccent), // Icon color
            const SizedBox(width: 8),
            Text(
              'WeatherMan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent, // Text color
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome to WeatherMan!',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.deepPurple, // Title color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                labelStyle: const TextStyle(color: Colors.deepPurple), // Label color
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple), // Focused border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple.shade100), // Default border color
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Enter your city',
                labelStyle: const TextStyle(color: Colors.deepPurple), // Label color
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple), // Focused border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple.shade100), // Default border color
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color
                foregroundColor: Colors.white, // Button text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              onPressed: () {
                String userName = nameController.text.trim();
                String cityName = cityController.text.trim();

                if (userName.isNotEmpty && cityName.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeatherScreen(
                        userName: userName,
                        city: cityName,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both name and city!'),
                    ),
                  );
                }
              },
              child: const Text(
                'Check Weather',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
