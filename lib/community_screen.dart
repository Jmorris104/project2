import 'package:flutter/material.dart';
import 'discussion_details.dart';

class CommunityDiscussionsScreen extends StatefulWidget {
  @override
  _CommunityDiscussionsScreenState createState() =>
      _CommunityDiscussionsScreenState();
}

class _CommunityDiscussionsScreenState
    extends State<CommunityDiscussionsScreen> {
  final List<Map<String, dynamic>> discussions = [];
  final TextEditingController _newDiscussionController =
      TextEditingController();

  void addNewDiscussion(String title) {
    setState(() {
      discussions.add({
        'title': title,
        'timestamp': DateTime.now(),
        'replies': [], // Initialize replies for this discussion
      });
    });
    _newDiscussionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Discussions"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newDiscussionController,
              decoration: InputDecoration(
                hintText: "Start a new discussion...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_newDiscussionController.text.isNotEmpty) {
                      addNewDiscussion(_newDiscussionController.text);
                    }
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: discussions.isEmpty
                  ? const Center(child: Text("No discussions yet."))
                  : ListView.builder(
                      itemCount: discussions.length,
                      itemBuilder: (context, index) {
                        final discussion = discussions[index];
                        return ListTile(
                          title: Text(discussion['title']),
                          subtitle: Text(
                              "Created on ${discussion['timestamp'].toString()}"),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DiscussionDetailsScreen(
                                  discussion: discussion,
                                  onReplyAdded: (reply) {
                                    setState(() {
                                      discussions[index]['replies'].add(reply);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
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
