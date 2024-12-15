import 'package:flutter/material.dart';
import 'registration_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, Map<String, String>> users; // Updated to support nested maps
  LoginScreen({required this.users, Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (widget.users.containsKey(email) &&
        widget.users[email]?['password'] == password) {
      final screenName = widget.users[email]?['screenName'] ?? 'User';
      // Successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: email,
            screenName: screenName,
          ),
        ),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Field
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),

            // Password Field
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            ),

            // Navigate to Registration Screen
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegistrationScreen(users: widget.users),
                  ),
                );
              },
              child: const Text("Don't have an account? Register here"),
            ),
          ],
        ),
      ),
    );
  }
}
