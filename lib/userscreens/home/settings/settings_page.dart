import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/address_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/debit_card_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/feedback_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/settings/support_page.dart';


class SettingsPopup extends StatelessWidget {
  const SettingsPopup({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Show the dialog immediately when this page is pushed
      showDialog(
        context: context,
        barrierDismissible: true, // Allow dismissing the dialog by tapping outside
        builder: (BuildContext context) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0.3), // Optional semi-transparent overlay
                ),
              ),
              // Dialog in the center
              Center(
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 300, // Adjust the width as needed
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(thickness: 1),
                        _buildSettingsOption('Address', Icons.location_on, context, const AddressPage()),
                        const Divider(thickness: 1),
                        _buildSettingsOption('Debit Card', Icons.credit_card, context, const DebitCardPage()),
                        const Divider(thickness: 1),
                        _buildSettingsOption('Feedback', Icons.feedback, context, const FeedbackPage()),
                        const Divider(thickness: 1),
                        _buildSettingsOption('Customer Support', Icons.support_agent, context, const SupportPage()),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          ),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });

    // Empty Scaffold since the dialog will appear immediately
    return const Scaffold(
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildSettingsOption(String title, IconData icon, BuildContext context, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.orange),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
