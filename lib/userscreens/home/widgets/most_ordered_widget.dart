import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'menu_widgets.dart';

class MenuList extends StatelessWidget {
  final List<String> collectionNames;

  const MenuList({super.key, required this.collectionNames});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: collectionNames.map((collectionName) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(collectionName)
                .where('isMostOrdered', isEqualTo: true) // Filter for most ordered items
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No items found'));
              }

              final items = snapshot.data!.docs;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: items.length,
                shrinkWrap: true, // Ensures the GridView only takes the space it needs
                physics: const NeverScrollableScrollPhysics(), // Prevents extra scroll
                itemBuilder: (context, index) {
                  final item = items[index].data() as Map<String, dynamic>;

                  return MenuWidgets(
                    imagePath: item['image'], // Replace with the correct field name
                    name: item['name'], // Replace with the correct field name
                    price: item['price'].toString(), // Replace with the correct field name
                    onPressed: () {
                      // You can pass your cart add functionality here
                    },
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
