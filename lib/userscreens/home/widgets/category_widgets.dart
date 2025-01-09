import 'package:flutter/material.dart';

class CustomRoundedContainer extends StatelessWidget {
  final String imagePath;

  const CustomRoundedContainer({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Adjust width as needed
      height: 120, // Adjust height as needed
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 246, 244), // Background color
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 6.0, // How much the shadow is blurred
            spreadRadius: 2.0, // How much the shadow spreads
            offset: const Offset(4.0, 4.0), // Position of the shadow (horizontal, vertical)
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0), // Space from top
        child: Center(
          child: Container(
            width: 60, // Circular container size
            height: 60, // Circular container size
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle, // Make it circular
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                width: 60, // Match the image size to the circular container
                height: 60, // Match the image size to the circular container
                fit: BoxFit.cover, // Fit image inside the circle
              ),
            ),
          ),
        ),
      ),
    );
  }
}
