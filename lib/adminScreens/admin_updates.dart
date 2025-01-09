import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminUpdates extends StatelessWidget {
  const AdminUpdates({super.key});

  void _updateOrderStatus({
    required String userId,
    required String cartId,
    required bool isCancelled,
    required bool isAccepted,
    required BuildContext context,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart')
          .doc(cartId);

      if (isCancelled) {
        await docRef.update({'isCancelled': true, 'isAccepted': false});
      } else if (isAccepted) {
        await docRef.update({'isAccepted': true, 'isCancelled': false});
      } else {
        final now = DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd').format(now);
        await docRef.update({
          'isAccepted': true,
          'statusMessage': 'Order accepted',
          'requiredDate': formattedDate,
        });
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.pink,
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
                    final cartId = items[index].id;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (!userSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final firstName =
                            userSnapshot.data?.get('firstName') ?? 'Unknown User';

                        if (item['isCancelled'] == true) {
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Order by $firstName is cancelled. Notification will be sent.'),
                              subtitle: Text(
                                'Order details: ${item['name'] ?? 'Unknown'}',
                              ),
                            ),
                          );
                        } else if (item['isAccepted'] == true) {
                          return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text('Order by $firstName is accepted'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Order details:'),
                                Text('Booking Date: ${item['requiredDate'] ?? 'N/A'}'),
                                Text('Flavour: ${item['flavour'] ?? 'N/A'}'),
                                Text('Pickup Option: ${item['pickupOption'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                        );
                        } else {
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('$firstName has ordered ${item['name'] ?? 'an item'}'),
                              subtitle: const Text('Action required.'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle, color: Colors.green),
                                    onPressed: () => _updateOrderStatus(
                                      userId: user.uid,
                                      cartId: cartId,
                                      isCancelled: false,
                                      isAccepted: true,
                                      context: context,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () => _updateOrderStatus(
                                      userId: user.uid,
                                      cartId: cartId,
                                      isCancelled: true,
                                      isAccepted: false,
                                      context: context,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
