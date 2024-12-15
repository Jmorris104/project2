import 'package:flutter/material.dart';
import 'google_book_api.dart';

class RecommendationsScreen extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const RecommendationsScreen({required this.favorites, Key? key})
      : super(key: key);

  Future<List<Map<String, String>>> generateRecommendations() async {
    if (favorites.isEmpty) {
      return [];
    }

    // Extract keywords from favorite books (e.g., genres or authors)
    final keywords = favorites.map((book) => book['title']!).toList();

    // Generate recommendations using keywords
    final List<Map<String, String>> recommendations = [];
    for (var keyword in keywords) {
      final books = await GoogleBooksAPI.fetchBooks(keyword);
      recommendations.addAll(books);
    }

    // Remove duplicates and return top recommendations
    return recommendations.toSet().toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: generateRecommendations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No recommendations available.'),
            );
          }

          final recommendations = snapshot.data!;
          return ListView.builder(
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final book = recommendations[index];
              return ListTile(
                leading: book['thumbnail']!.isNotEmpty
                    ? Image.network(book['thumbnail']!, width: 50, height: 50)
                    : const Icon(Icons.book),
                title: Text(book['title']!),
                subtitle: Text(book['author']!),
              );
            },
          );
        },
      ),
    );
  }
}
