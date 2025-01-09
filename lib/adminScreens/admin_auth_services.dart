import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/adminScreens/admin_nav_bar.dart';

class AdminAuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Admin Sign In Method
  Future<void> adminSignIn({
    required String email,
    required String password,
    required BuildContext context,
    required Function(bool isLoading) onLoading,
    required Function(String? errorMessage) onError,
  }) async {
    onLoading(true); // Start loading

    try {
      // Sign in the user
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user is in the 'admins' collection
      DocumentSnapshot adminDoc = await _firestore
          .collection('admins')
          .doc(userCredential.user!.uid)
          .get();

      if (adminDoc.exists) {
        // Navigate to AdminNavigationMenu
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminNavigationMenu()),
        );
      } else {
        onError('Unauthorized access.');
      }
    } catch (e) {
      onError('Invalid email or password.');
    } finally {
      onLoading(false); // Stop loading
    }
  }
}
