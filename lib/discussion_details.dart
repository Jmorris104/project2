import 'package:flutter/material.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> discussion;

  const DiscussionDetailsScreen({required this.discussion, Key? key}) : super(key: key);

  @override
  _DiscussionDetailsScreenState createState() => _DiscussionDetailsScreenState();
}

class _DiscussionDetailsScreenState extends State<DiscussionDetailsScreen> {
  final TextEditingController replyController = TextEditingController();

  void _addReply(String reply) {
    setState(() {
      widget.discussion['replies'].add(reply);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discussion['title']),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.discussion['replies'].length,
              itemBuilder: (context, index) {
                final reply = widget.discussion['replies'][index];
                return ListTile(
                  title: Text(reply),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: replyController,
                    decoration: const InputDecoration(hintText: 'Enter your reply...'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _addReply(replyController.text);
                    replyController.clear();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
