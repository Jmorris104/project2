import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoritesScreen({required this.favorites, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorites added yet!'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final book = favorites[index];
                return ListTile(
                  leading: Image.network(
                    book['thumbnail']!,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(book['title']!),
                  subtitle: Text('Author: ${book['author']}'),
                );
              },
            ),
    );
  }
}
