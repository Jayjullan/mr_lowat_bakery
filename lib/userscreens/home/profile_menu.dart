import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_lowat_bakery/userscreens/home/view_profile.dart';
import 'package:mr_lowat_bakery/userscreens/my_orders.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/settings_page.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({super.key});

  @override
  _ProfileMenuState createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  String userName = "Loading..."; // Placeholder for user's name

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      // Get the current user
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Replace with your Firestore collection name
            .doc(currentUser.uid) // Use the authenticated user's UID
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc['firstName']; // Access the "firstName" field
          });
        } else {
          setState(() {
            userName = "User"; // Fallback if document doesn't exist
          });
        }
      }
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        userName = "Error"; // Fallback on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture Section with Alphabet
            Container(
              width: 180, // Size of the circular ring
              height: 180,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U', // Display first letter of first name
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Display Fetched User Name
            Text(
              userName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 68, 68, 68),
              ),
            ),
            const SizedBox(height: 20), // Spacing before buttons
            // View Profile Button
            ProfileButton(
              label: "View Profile",
              onTap: () {
                // Navigate to the User Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfilePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // My Orders Button
            ProfileButton(
              label: "My Orders",
              onTap: () {
                // Navigate to the Order Tracker Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Settings Button
            ProfileButton(
              label: "Settings",
              onTap: () {
                // Show the Settings Dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const SettingsPopup(); // Call your SettingsPopup widget as a dialog
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Button Widget
class ProfileButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const ProfileButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 350,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 126, 19),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
