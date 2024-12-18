import 'package:fieldview/screens/auth_page.dart';
import 'package:fieldview/screens/landing_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return LandingPage(userName: "Hehe", city: "Bandung");
              } else {
                return AuthPage();
              }
            }));
  }
}
