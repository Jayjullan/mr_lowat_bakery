import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminMostOrder extends StatefulWidget {
  final List<String> collectionNames;

  const AdminMostOrder({super.key, required this.collectionNames});

  @override
  _AdminMostOrderPageState createState() => _AdminMostOrderPageState();
}

class _AdminMostOrderPageState extends State<AdminMostOrder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  void _addItem() async {
    try {
      await FirebaseFirestore.instance.collection('collectionNames').add({
        'name': _nameController.text,
        'price': _priceController.text,
        'image': _imageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding item: $e")),
      );
    }
  }

  void _updateItem(String id) async {
    try {
      await FirebaseFirestore.instance.collection('collectionNames').doc(id).update({
        'name': _nameController.text,
        'price': _priceController.text,
        'image': _imageController.text,
      });
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating item: $e")),
      );
    }
  }

  void _deleteItem(String id) async {
    try {
      await FirebaseFirestore.instance.collection('collectionNames').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting item: $e")),
      );
    }
  }

  void _showDialog({String? id, Map<String, dynamic>? data}) {
    if (data != null) {
      _nameController.text = data['name'];
      _priceController.text = data['price'];
      _imageController.text = data['image'];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(id == null ? "Add Item" : "Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (id == null) {
                  _addItem();
                } else {
                  _updateItem(id);
                }
              },
              child: Text(id == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: widget.collectionNames.map((collectionName) {
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
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = items[index].data() as Map<String, dynamic>;
                  final id = items[index].id;

                  return buildCard(id, item);
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }

   Widget buildCard(String id, Map<String, dynamic> item) {
  return Container(
    width: 180,
    height: 180, // Adjusted height to accommodate buttons below
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 247, 246, 244), // Background color
      borderRadius: BorderRadius.circular(20), // Rounded corners
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Shadow color
          blurRadius: 6.0, // Blur amount
          spreadRadius: 2.0, // Spread amount
          offset: const Offset(4.0, 4.0), // Shadow offset
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ), // Rounded top corners
          child: item['image'].toString().startsWith('http')
              ? Image.network(
                  item['image'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                  },
                )
              : Image.asset(
                  item['image'],
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                  },
                ),
        ),
        const SizedBox(height: 10),
        // Name and Price
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
                maxLines: 1, // Restrict to one line
                overflow: TextOverflow.ellipsis, // Ellipsis for overflow
              ),
              const SizedBox(height: 4),
              Text(
                'RM ${item['price']}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 13,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        // Edit and Delete Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Edit Button
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showDialog(id: id, data: item),
              ),
              // Delete Button
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteItem(id),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}