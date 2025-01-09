import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.orange,
      ),
      body: user == null
          ? const Center(
              child: Text('Please log in to view your notifications.'),
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
                    child: Text('No notifications available.'),
                  );
                }

                final items = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index].data() as Map<String, dynamic>;
                    final itemName = item['name'] ?? 'Unknown Item';
                    final isCancelled = item['isCancelled'] ?? false;
                    final isAccepted = item['isAccepted'] ?? false;
                    final requiredDate = item['requiredDate'] ?? 'Unknown Date';

                    List<Widget> notifications = [];

                    // Add notification for isPaid
                    notifications.add(
                      Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(itemName),
                          subtitle: const Text('Your order is paid. We will notify the bakery.'),
                        ),
                      ),
                    );

                    // Add notification for isAccepted
                    if (isAccepted) {
                      notifications.add(
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(itemName),
                            subtitle: const Text('Your order is in the kitchen.'),
                          ),
                        ),
                      );
                    }

                    // Add notification for isCancelled
                    if (isCancelled) {
                      notifications.add(
                        Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(itemName),
                            subtitle: Text(
                              'Your order ($itemName) scheduled for delivery on $requiredDate is cancelled. Please contact the bakery for more information. Your refund is in process.',
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: notifications,
                    );
                  },
                );
              },
            ),
    );
  }
}
