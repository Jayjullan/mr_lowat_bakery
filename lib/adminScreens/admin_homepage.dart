import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/adminScreens/admincakes.dart';
import 'package:mr_lowat_bakery/adminScreens/admincheesecake.dart';
import 'package:mr_lowat_bakery/adminScreens/admintart.dart';
import 'package:mr_lowat_bakery/adminScreens/adminbrownies.dart';
import 'package:mr_lowat_bakery/adminScreens/admincupcake.dart';
import 'package:mr_lowat_bakery/adminScreens/adminothers.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_most_ordered.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/category_widgets.dart';

class AdminHomepage extends StatelessWidget {
  const AdminHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 225, 225),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        elevation: 0,
        title: const Text(
          "Admin Home",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Settings action
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Edit functionality
              print("Edit action triggered");
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(image: AssetImage('assets/homeAds.png')),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Discover by category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminBurntCheesecakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cheesecake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminBrowniesPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/brownie.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCheeseTartPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/egg-tart.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminCupcakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cupcake.png'),
                      ),
                      const SizedBox(width: 14),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminOthersPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/puffs.png'),
                      ),
                      const SizedBox(width: 14),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Most Ordered',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // Corrected the padding widget for MostOrderedPage
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    AdminMostOrder(collectionNames: ['cakes']),
                    SizedBox(height: 10), // Space between items
                    AdminMostOrder(collectionNames: ['burntCheesecakes']),
                    SizedBox(height: 10), // Space between items
                    AdminMostOrder(collectionNames: ['brownies']),
                    SizedBox(height: 10), // Space between items
                    AdminMostOrder(collectionNames: ['cheeseTarts']),
                    SizedBox(height: 10), // Space between items
                    AdminMostOrder(collectionNames: ['cupcakes']),
                    SizedBox(height: 10), // Space between items
                    AdminMostOrder(collectionNames: ['others']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
