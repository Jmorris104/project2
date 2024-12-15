import 'package:flutter/material.dart';
import 'review_screen.dart';
class BookDetailsScreen extends StatelessWidget {
  final Map<String, String> book;
  final List<Map<String, String>> favorites;

  const BookDetailsScreen({
    required this.book,
    required this.favorites,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String title = book['title'] ?? 'No Title Available';
    final String author = book['author'] ?? 'Unknown Author';
    final String description = book['description'] ?? 'No description available.';
    final String thumbnail = book['thumbnail'] ?? '';

    // Simulated reviews map (you can integrate this with your existing structure)
    final Map<String, List<Map<String, dynamic>>> reviews = {};

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: thumbnail.isNotEmpty
                        ? Image.network(
                            thumbnail,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 100),
                          )
                        : const Icon(Icons.book, size: 100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'by $author',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    final alreadyInFavorites = favorites.any(
                      (favBook) => favBook['title'] == title,
                    );

                    if (alreadyInFavorites) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$title is already in favorites!'),
                        ),
                      );
                    } else {
                      Navigator.pop(context, book);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$title added to favorites!'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Add to Favorites"),
                ),
                const SizedBox(height: 10),
                // Write Review Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WriteReviewScreen(
                          book: book,
                          reviews: reviews,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.orange,
                  ),
                  child: const Text("Write a Review"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
