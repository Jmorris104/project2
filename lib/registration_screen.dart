import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  final Map<String, Map<String, String>> users; // Updated to handle nested users map

  const RegistrationScreen({required this.users, Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController screenNameController = TextEditingController();

  void register() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final screenName = screenNameController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty && screenName.isNotEmpty) {
      if (widget.users.containsKey(email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is already registered.')),
        );
      } else {
        // Add new user to the users map
        setState(() {
          widget.users[email] = {
            'password': password,
            'screenName': screenName,
          };
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful!')),
        );
        Navigator.pop(context); // Navigate back to login screen
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
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
            const SizedBox(height: 10),

            // Screen Name Field
            TextField(
              controller: screenNameController,
              decoration: const InputDecoration(labelText: "Screen Name"),
            ),
            const SizedBox(height: 20),

            // Register Button
            ElevatedButton(
              onPressed: register,
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
