import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'book_details.dart';
import 'community_screen.dart';

class HomeScreen extends StatefulWidget {
  final String email;

  const HomeScreen({required this.email, Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> books = [];
  List<Map<String, String>> favorites = [];

  @override
  void initState() {
    super.initState();
    fetchBooks(); // Fetch default books
  }

  Future<void> fetchBooks([String query = 'fiction']) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=20';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          books = (data['items'] as List).map<Map<String, String>>((item) {
            final volumeInfo = item['volumeInfo'];
            return {
              'title': volumeInfo['title'] ?? 'No Title',
              'author': (volumeInfo['authors'] != null)
                  ? (volumeInfo['authors'] as List).join(', ')
                  : 'Unknown Author',
              'description': volumeInfo['description'] ?? 'No Description',
              'thumbnail': volumeInfo['imageLinks']?['thumbnail'] ?? '',
            };
          }).toList();
        });
      } else {
        print('Failed to fetch books: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching books: $e');
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Recommendations'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Logged in as: ${widget.email}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(favorites: favorites),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Community Discussions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityDiscussionsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Implement settings page
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (query) {
                fetchBooks(query); // Fetch books based on the search query
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: books.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsScreen(
                                  book: book,
                                  favorites: favorites,
                                ),
                              ),
                            ).then((result) {
                              if (result != null) {
                                setState(() {
                                  favorites.add(result);
                                });
                              }
                            });
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

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, String>> favorites;

  const FavoritesScreen({required this.favorites, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final book = favorites[index];
          return ListTile(
            leading: book['thumbnail']!.isNotEmpty
                ? Image.network(book['thumbnail']!, height: 50, width: 50)
                : const Icon(Icons.book),
            title: Text(book['title']!),
            subtitle: Text(book['author']!),
          );
        },
      ),
    );
  }
}
