import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book_details.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  HomeScreen({required this.email}); // Add the email parameter

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> books = [];
  List<Map<String, String>> favorites = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks([String query = 'fiction']) async {
    try {
      final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = (data['items'] as List).map<Map<String, String>>((item) {
            final volumeInfo = item['volumeInfo'] as Map<String, dynamic>? ?? {};
            final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>? ?? {};
            return {
              'title': (volumeInfo['title'] ?? 'Unknown Title').toString(),
              'author': (volumeInfo['authors'] != null
                      ? (volumeInfo['authors'] as List).join(', ')
                      : 'Unknown Author')
                  .toString(),
              'thumbnail': (imageLinks['thumbnail'] ?? '').toString(),
              'description': (volumeInfo['description'] ?? 'No description available.').toString(),
            };
          }).toList();
        });
      } else {
        print('Failed to fetch books: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching books: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.email}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favorites: favorites),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search for books...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                fetchBooks(value);
              },
            ),
            const SizedBox(height: 20),
            books.isEmpty
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      itemCount: books.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return GestureDetector(
                          onTap: () async {
                            final selectedBook = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsScreen(book: book),
                              ),
                            );
                            if (selectedBook != null) {
                              setState(() {
                                favorites.add(selectedBook);
                              });
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: book['thumbnail']!.isNotEmpty
                                      ? Image.network(
                                          book['thumbnail']!,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(Icons.book, size: 50),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                book['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                book['author']!,
                                style: const TextStyle(color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
