import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksAPI {
  static Future<List<Map<String, String>>> fetchBooks(String query) async {
    try {
      final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List<dynamic>?;

        if (items != null) {
          return items.map<Map<String, String>>((item) {
            final volumeInfo = item['volumeInfo'] as Map<String, dynamic>? ?? {};
            return {
              'title': volumeInfo['title'] ?? 'No Title',
              'author': (volumeInfo['authors'] as List<dynamic>?)?.join(', ') ?? 'Unknown Author',
              'description': volumeInfo['description'] ?? 'No description available.',
              'thumbnail': (volumeInfo['imageLinks']?['thumbnail'] as String?) ?? '',
            };
          }).toList();
        }
      }
    } catch (e) {
      print('Error fetching books: $e');
    }
    return [];
  }
}
