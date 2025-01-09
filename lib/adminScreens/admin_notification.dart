import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCustomerFeedback extends StatelessWidget {
  const AdminCustomerFeedback({super.key});

  Future<List<Map<String, dynamic>>> _fetchAllFeedback() async {
    final feedbackList = <Map<String, dynamic>>[];

    final userDocs = await FirebaseFirestore.instance.collection('users').get();

    for (var user in userDocs.docs) {
      final userFeedback = await user.reference.collection('feedback').get();
      for (var feedbackDoc in userFeedback.docs) {
        feedbackList.add({
          ...feedbackDoc.data(),
          'userName': user['firstName'] ?? 'Unknown User', // Fetch user's first name
        });
      }
    }

    return feedbackList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Customer Feedback'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchAllFeedback(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No feedback available.'),
            );
          }

          final feedbackData = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: feedbackData.length,
            itemBuilder: (context, index) {
              final feedback = feedbackData[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                color: const Color.fromARGB(255, 255, 91, 145),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  title: Text(
                    feedback['userName'] ?? 'Anonymous',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    feedback['detailedFeedback'] ?? 'No feedback provided.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            title: const Text('Feedback Details'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'User: ${feedback['userName'] ?? 'Anonymous'}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Rating: ${feedback['rating'] ?? 'N/A'}'),
                                  const SizedBox(height: 8),
                                  Text('Improvement: ${feedback['improvement'] ?? 'N/A'}'),
                                  const SizedBox(height: 8),
                                  Text('Details: ${feedback['detailedFeedback'] ?? 'N/A'}'),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'View Details',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
