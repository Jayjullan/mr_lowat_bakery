import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: Colors.orange,
      ),
      body: user == null
          ? const Center(
              child: Text('Please log in to view your orders.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('cart')
                  .where('isPaid', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No orders available.'),
                  );
                }

                final items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index].data() as Map<String, dynamic>;
                    final itemName = item['name'] ?? 'Unknown Item';
                    final bookingDate = item['bookingDate'] ?? 'Unknown Date';
                    final isAccepted = item['isAccepted'] ?? false;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(itemName),
                        subtitle: Text('Booking Date: $bookingDate'),
                        trailing: ElevatedButton(
                          onPressed: () => _showOrderDetails(context, item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('View Details'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    final itemName = order['name'] ?? 'Unknown Item';
    final bookingDate = order['bookingDate'] ?? 'Unknown Date';
    final isAccepted = order['isAccepted'] ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Order Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Item: $itemName'),
              Text('Booking Date: $bookingDate'),
              const SizedBox(height: 12),
              const Text('Order Progress:'),
              ListTile(
                leading: Icon(
                  isAccepted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isAccepted ? Colors.green : Colors.grey,
                ),
                title: const Text('Order Accepted'),
              ),
              ListTile(
                leading: Icon(
                  order['isPaid'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: order['isPaid'] == true ? Colors.green : Colors.grey,
                ),
                title: const Text('Payment Completed'),
              ),
            ],
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
  }
}
