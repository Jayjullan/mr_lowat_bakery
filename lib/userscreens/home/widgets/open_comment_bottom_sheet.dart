import 'package:flutter/material.dart';

void openCommentsBottomSheet({
  required BuildContext context,
  required List<Map<String, String>> comments,
  required Function(String) onAddComment,
}) {
  final TextEditingController commentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Comments List (Wrapped in Expanded or SingleChildScrollView)
            SizedBox(
              height: 300,  // Optional: set a fixed height or remove if you want dynamic
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  final comment = comments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          child: Text(comment['author']![0]),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment['author']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(comment['message']!),
                              TextButton(
                                onPressed: () {
                                  // Handle reply (optional)
                                },
                                child: const Text('Reply'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            // Handle like (optional)
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Add Comment Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    final comment = commentController.text.trim();
                    if (comment.isNotEmpty) {
                      onAddComment(comment);
                      commentController.clear();
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
