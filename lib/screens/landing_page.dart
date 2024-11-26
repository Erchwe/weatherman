import 'package:flutter/material.dart';
import 'weather_screen.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // lottie animasi
              Lottie.asset(
                'assets/weather_animation.json',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Welcome to WeatherMan!',
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ),

              // quote
              const Text(
                '"There’s no such thing as bad weather, only different kinds of good weather." – John Ruskin',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                  fontSize: 14,
                ),
              ),    
              const SizedBox(height: 24),

              // input
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: Colors.purple),
                  labelStyle: TextStyle(
                    color: Colors.purple,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple), 
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black), 
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  hintText: "Enter your city",
                  hintStyle: TextStyle(color: Colors.purple),
                  labelStyle: TextStyle(
                    color: Colors.purple, 
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple), 
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(color: Colors.black), 
              ),
              const SizedBox(height: 24),

              // button check weather
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                child: const Text('Check Weather'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
