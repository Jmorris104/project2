import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String email;

  HomeScreen({required this.email});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> books = []; // Store fetched books
  String searchQuery = "fiction"; // Default search query
  bool isLoading = false; // Show loading state

  @override
  void initState() {
    super.initState();
    fetchBooks(searchQuery); // Fetch books when screen loads
  }

  Future<void> fetchBooks(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Map<String, String>> fetchedBooks = (data['items'] as List)
            .map<Map<String, String>>((item) {
          final volumeInfo = item['volumeInfo'] ?? {};
          final imageLinks = volumeInfo['imageLinks'] ?? {};

          return {
            'title': (volumeInfo['title'] ?? 'Unknown Title').toString(),
            'author': (volumeInfo['authors'] != null
                    ? (volumeInfo['authors'] as List).join(', ')
                    : 'Unknown Author')
                .toString(),
            'image': (imageLinks['thumbnail'] ?? '').toString(),
            'description': (volumeInfo['description'] ?? 'No description available.')
                .toString(),
          };
        }).toList();

        setState(() {
          books = fetchedBooks;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print("Error fetching books: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${widget.email}"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search for books...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  fetchBooks(value); // Fetch books based on search query
                }
              },
            ),
            SizedBox(height: 16),
            // Book Recommendations or Loading Indicator
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : books.isEmpty
                      ? Center(child: Text("No books found."))
                      : ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                leading: book['image']!.isNotEmpty
                                    ? Image.network(book['image']!, width: 50)
                                    : Icon(Icons.book, size: 50),
                                title: Text(
                                  book['title']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "${book['author']}\n${book['description']}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
