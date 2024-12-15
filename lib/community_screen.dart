import 'package:flutter/material.dart';

class CommunityDiscussionsScreen extends StatefulWidget {
  @override
  _CommunityDiscussionsScreenState createState() => _CommunityDiscussionsScreenState();
}

class _CommunityDiscussionsScreenState extends State<CommunityDiscussionsScreen> {
  final TextEditingController _discussionController = TextEditingController();
  final List<Map<String, dynamic>> discussions = [];

  void addDiscussion(String content) {
    setState(() {
      discussions.add({
        'content': content,
        'timestamp': DateTime.now(),
        'replies': [],
      });
    });
    _discussionController.clear();
  }

  void addReply(int index, String reply) {
    setState(() {
      discussions[index]['replies'].add({
        'content': reply,
        'timestamp': DateTime.now(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Discussions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _discussionController,
              decoration: InputDecoration(
                hintText: 'Start a new discussion...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_discussionController.text.trim().isNotEmpty) {
                      addDiscussion(_discussionController.text.trim());
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: discussions.length,
              itemBuilder: (context, index) {
                final discussion = discussions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ExpansionTile(
                    title: Text(
                      discussion['content'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Posted on ${discussion['timestamp'].toString()}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    children: [
                      ...discussion['replies'].map<Widget>((reply) {
                        return ListTile(
                          title: Text(reply['content']),
                          subtitle: Text(
                            'Replied on ${reply['timestamp'].toString()}',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Reply to this discussion...',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {
                                // Capture reply
                                final replyController = TextEditingController();
                                if (replyController.text.trim().isNotEmpty) {
                                  addReply(index, replyController.text.trim());
                                  replyController.clear();
                                }
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
