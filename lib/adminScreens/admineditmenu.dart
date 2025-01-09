import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/adminScreens/admincakes.dart';
import 'package:mr_lowat_bakery/adminScreens/admincheesecake.dart';
import 'package:mr_lowat_bakery/adminScreens/admintart.dart';
import 'package:mr_lowat_bakery/adminScreens/adminbrownies.dart';
import 'package:mr_lowat_bakery/adminScreens/admincupcake.dart';
import 'package:mr_lowat_bakery/adminScreens/adminothers.dart';

class AdminEditMenu extends StatefulWidget {
  const AdminEditMenu({super.key});

  @override
  _AdminEditMenuState createState() => _AdminEditMenuState();
}

class _AdminEditMenuState extends State<AdminEditMenu> {
  final List<Map<String, dynamic>> hardcodedCategories = [
    {'imagePath': 'assets/cake.png', 'name': 'Cakes', 'page': const AdminCakePage()},
    {'imagePath': 'assets/cheesecake.png', 'name': 'Burnt Cheesecake', 'page': const AdminBurntCheesecakePage()},
    {'imagePath': 'assets/brownie.png', 'name': 'Brownies', 'page': const AdminBrowniesPage()},
    {'imagePath': 'assets/egg-tart.png', 'name': 'Cheese Tart', 'page': const AdminCheeseTartPage()},
    {'imagePath': 'assets/cupcake.png', 'name': 'Cupcakes', 'page': const AdminCupcakePage()},
    {'imagePath': 'assets/puffs.png', 'name': 'Others', 'page': const AdminOthersPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 225, 225),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Admin Edit Menu'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          final dynamicCategories = snapshot.data?.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'imagePath': data['imagePath'],
              'name': data['name'],
              'page': null, // Dynamic categories don't link to a specific page
            };
          }).toList();

          final categories = [
            ...hardcodedCategories,
            if (dynamicCategories != null) ...dynamicCategories,
          ];

          if (!snapshot.hasData && dynamicCategories == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];

                return GestureDetector(
                  onTap: () {
                    if (category['page'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => category['page'] as Widget),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No page linked for ${category['name']}')),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              category['imagePath'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          category['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
