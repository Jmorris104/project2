import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']!),
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
                    child: book['thumbnail']!.isNotEmpty
                        ? Image.network(
                            book['thumbnail']!,
                            height: 200,
                          )
                        : const Icon(Icons.book, size: 100),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    book['title']!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'by ${book['author']}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    book['description']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Check if the book is already in favorites
                final alreadyInFavorites = favorites.any(
                  (favBook) => favBook['title'] == book['title'],
                );

                if (alreadyInFavorites) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${book['title']} is already in favorites!'),
                    ),
                  );
                } else {
                  Navigator.pop(context, book); // Return the book to add to favorites
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${book['title']} added to favorites!'),
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
          ),
        ],
      ),
    );
  }
}
