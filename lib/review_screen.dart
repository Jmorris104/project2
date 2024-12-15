import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  final Map<String, String> book;
  final Map<String, List<Map<String, dynamic>>> reviews;

  const WriteReviewScreen({
    required this.book,
    required this.reviews,
    Key? key,
  }) : super(key: key);

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  int selectedRating = 0;

  void addReview(String review) {
    // Safely add the review
    final bookTitle = widget.book['title'];
    if (bookTitle != null) {
      setState(() {
        widget.reviews.putIfAbsent(bookTitle, () => []);
        widget.reviews[bookTitle]!.add({
          'review': review,
          'rating': selectedRating,
          'timestamp': DateTime.now().toString(),
        });
      });

      // Clear inputs after adding the review
      _reviewController.clear();
      selectedRating = 0;

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookTitle = widget.book['title'] ?? 'Unknown Book';

    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review for $bookTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
              onChanged: (_) {
                setState(() {}); // Update UI when the text changes
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: selectedRating > index ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                );
              }),
            ),
            ElevatedButton(
              onPressed: _reviewController.text.isNotEmpty && selectedRating > 0
                  ? () => addReview(_reviewController.text)
                  : null,
              child: const Text('Submit Review'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: widget.reviews[widget.book['title']]?.isEmpty ?? true
                  ? const Center(child: Text('No reviews yet.'))
                  : ListView.builder(
                      itemCount: widget.reviews[widget.book['title']]!.length,
                      itemBuilder: (context, index) {
                        final review = widget.reviews[widget.book['title']]![index];
                        return ListTile(
                          title: Text(review['review']),
                          subtitle: Text(
                              'Rating: ${review['rating']} | ${review['timestamp']}'),
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
