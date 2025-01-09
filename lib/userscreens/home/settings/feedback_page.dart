import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0;
  String? _selectedImprovement = '';
  final TextEditingController _improvementController = TextEditingController();

  Future<void> _submitFeedback() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? "Anonymous";

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in. Cannot submit feedback.')),
      );
      return;
    }

    if (_improvementController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Detailed feedback cannot be empty.')),
      );
      return;
    }

    final feedback = {
      'rating': _rating,
      'improvement': _selectedImprovement,
      'detailedFeedback': _improvementController.text,
      'timestamp': FieldValue.serverTimestamp(),
      'userName': userName,
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('feedback')
          .add(feedback);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback Submitted')),
      );

      // Reset the fields
      setState(() {
        _rating = 0;
        _selectedImprovement = '';
        _improvementController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit feedback: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              'Rate your experience:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: const Color.fromARGB(255, 244, 192, 36),
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),

            const Text(
              'What can we improve?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                'Overall Service',
                'Repair Quality',
                'Transparency',
                'Customer Support',
                'Pickup and Delivery Service',
                'Speed and Efficiency',
              ].map((option) {
                return ChoiceChip(
                  label: Text(option),
                  selected: _selectedImprovement == option,
                  onSelected: (selected) {
                    setState(() {
                      _selectedImprovement = selected ? option : '';
                    });
                  },
                  selectedColor: Colors.orange.withOpacity(0.8),
                  backgroundColor: Colors.grey.shade200,
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            const Text(
              'What else can we improve?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _improvementController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Enter your detailed feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
