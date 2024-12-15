import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String email;
  final String screenName;
  final Function(String) onScreenNameUpdated;

  const SettingsScreen({
    required this.email,
    required this.screenName,
    required this.onScreenNameUpdated,
    Key? key,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _screenNameController;

  @override
  void initState() {
    super.initState();
    _screenNameController = TextEditingController(text: widget.screenName);
  }

  @override
  void dispose() {
    _screenNameController.dispose();
    super.dispose();
  }

  void _updateScreenName() {
    widget.onScreenNameUpdated(_screenNameController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Screen name updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.email),
            const SizedBox(height: 16),
            const Text(
              'Screen Name:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _screenNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Screen Name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateScreenName,
              child: const Text('Update Screen Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
