import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/welcome.dart';
import 'package:firebase_core/firebase_core.dart'; //dpt from firebase setup


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDzTktXgjlgEqd8E6t0k6HzWv03xyBErFY",
            authDomain: "mr-lowat-bakery.firebaseapp.com",
            projectId: "mr-lowat-bakery",
            storageBucket: "mr-lowat-bakery.firebasestorage.app",
            messagingSenderId: "109927117800",
            appId: "1:109927117800:web:86c4c70da6b56b87e0aa5d"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the debug banner
      title: 'Mr Lowat Bakery',
      theme: ThemeData(
        primarySwatch: Colors.orange, // Set your primary color theme
      ),
      home:
          const BakeryWelcomeScreen(), // Set your welcome screen as the home page
    );
  }
}
