import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminOrderList(),
    );
  }
}

class AdminOrderList extends StatefulWidget {
  const AdminOrderList({super.key});

  @override
  _AdminOrderListState createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  final List<String> processStages = ["Accepted", "Processing", "Ready", "Completed"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0,
        title: const Text(
          "Order List",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No orders available."),
            );
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final cartId = orders[index].id;
              final userId = orders[index].reference.parent.parent!.id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(
                    "${order['name'] ?? 'Unknown Item'}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                        builder: (context, userSnapshot) {
                          if (!userSnapshot.hasData) return const Text("Loading...");
                          final user = userSnapshot.data?.data() as Map<String, dynamic>? ?? {};
                          return Text("Customer: ${user['firstName'] ?? 'Unknown'}");
                        },
                      ),
                      const SizedBox(height: 8),
                      Text("Booking Date: ${order['bookingDate'] ?? 'N/A'}"),
                      Text("Flavour: ${order['flavour'] ?? 'N/A'}"),
                      Text("Pickup Option: ${order['pickupOption'] ?? 'N/A'}"),
                      Text("Price: ${order['price']?.toString() ?? 'N/A'}"),
                    ],
                  ),
                  trailing: DropdownButton<String>(
                    value: order['status'] ?? processStages[0],
                    items: processStages.map((stage) {
                      return DropdownMenuItem(
                        value: stage,
                        child: Text(stage),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('cart')
                          .doc(cartId)
                          .update({'status': newStatus});
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Order updated to $newStatus")),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<QueryDocumentSnapshot>> _fetchOrders() async {
    List<QueryDocumentSnapshot> allOrders = [];

    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var userDoc in usersSnapshot.docs) {
      final cartSnapshot = await userDoc.reference
          .collection('cart')
          .where('isAccepted', isEqualTo: true)
          .get();
      allOrders.addAll(cartSnapshot.docs);
    }

    return allOrders;
  }
}
