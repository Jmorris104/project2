import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initial users map (in-memory database)
    final Map<String, Map<String, String>> users = {
      'test@example.com': {'password': 'password123', 'screenName': 'TestUser'},
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Recommendations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(users: users), // Pass the users map here
    );
  }
}
