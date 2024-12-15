import 'package:flutter/material.dart';

class DiscussionDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> discussion;
  final Function(Map<String, dynamic>) onReplyAdded;

  const DiscussionDetailsScreen({
    required this.discussion,
    required this.onReplyAdded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(discussion['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Created on ${discussion['timestamp'].toString()}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: discussion['replies'].length,
                itemBuilder: (context, index) {
                  final reply = discussion['replies'][index];
                  return ListTile(
                    title: Text(reply['reply']),
                    subtitle: Text(
                      "Replied on ${reply['timestamp'].toString()}",
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            TextField(
              controller: replyController,
              decoration: InputDecoration(
                hintText: "Write a reply...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (replyController.text.isNotEmpty) {
                      onReplyAdded({
                        'reply': replyController.text.trim(),
                        'timestamp': DateTime.now(),
                      });
                      replyController.clear();
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
