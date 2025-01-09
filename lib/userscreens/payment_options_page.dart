import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/homepage.dart';

class PaymentOptionsPage extends StatefulWidget {
  const PaymentOptionsPage({super.key, required bool isDelivery, required addOns, required double price, required String cartItemId, required String userId});

  @override
  _PaymentOptionsPageState createState() => _PaymentOptionsPageState();
}

class _PaymentOptionsPageState extends State<PaymentOptionsPage> {
  String selectedPaymentMethod = '';
  String? selectedBank;
  bool cardSaved = false;
  double subtotal = 80.0;
  double addOn = 10.0;
  double shipping = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              'Payment',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.radio_button_checked,
                color: selectedPaymentMethod.isNotEmpty ? Colors.orange : Colors.grey,
              ),
              Container(width: 50, height: 2, color: Colors.orange),
              Icon(
                Icons.radio_button_unchecked,
                color: selectedPaymentMethod == 'Confirmation' ? Colors.orange : Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select payment method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPaymentMethodIcon(Icons.credit_card, 'Credit/Debit Card', 'Card'),
                      _buildPaymentMethodIcon(Icons.account_balance, 'Online Banking', 'Banking'),
                    ],
                  ),
                  const SizedBox(height: 30),
                  if (selectedPaymentMethod == 'Card') _buildCardDetailsSection(context),
                  if (selectedPaymentMethod == 'Banking') _buildBankingOptionsSection(),
                  const Divider(),
                  _buildSummarySection(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context); // Cancel button functionality
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Cancel'),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (selectedPaymentMethod == 'Banking' && selectedBank == 'CIMB Clicks') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CIMBClicksPage(),
              ),
            );
          } 
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text('Proceed to payment'),
      ),
    ),
  ],
),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

    Widget _buildPaymentMethodIcon(IconData icon, String label, String method) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
          selectedBank = null; // Reset the bank selection
        });
      },
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.orange),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetailsSection(BuildContext context) {
    TextEditingController cardHolderNameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();
    TextEditingController cvvController = TextEditingController();

    return Column(
      children: [
        TextField(
          controller: cardHolderNameController,
          decoration: const InputDecoration(
            labelText: 'Card Holder Name',
          ),
        ),
        TextField(
          controller: cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Card Number',
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: expiryDateController,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (cardHolderNameController.text.isNotEmpty &&
                cardNumberController.text.isNotEmpty &&
                expiryDateController.text.isNotEmpty &&
                cvvController.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfirmationPage(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please fill in all card details.'),
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _buildBankingOptionsSection() {
    return Column(
      children: [
        const Text(
          'Select a bank:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedBank,
          hint: const Text('Choose your bank'),
          items: const [
            DropdownMenuItem(value: 'Maybank2U', child: Text('Maybank2U')),
            DropdownMenuItem(value: 'CIMB Clicks', child: Text('CIMB Clicks')),
            DropdownMenuItem(value: 'Public Bank', child: Text('Public Bank')),
          ],
          onChanged: (value) {
            setState(() {
              selectedBank = value;
            });
          },
        ),
      ],
    );
  }


  Widget _buildSummarySection() {
    double total = subtotal + addOn + shipping;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(fontSize: 16)),
            Text('RM${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Add On', style: TextStyle(fontSize: 16)),
            Text('RM${addOn.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Shipping', style: TextStyle(fontSize: 16)),
            Text('RM${shipping.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('RM${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class CIMBClicksPage extends StatelessWidget {
  const CIMBClicksPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController userIdController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('CIMB Clicks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'CIMB Clicks Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter your CIMB Clicks login details to proceed with the payment.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.grey,
    minimumSize: const Size(150, 50),
  ),
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Pending'),
          content: const Text('Your payment is pending. You have 24 hours to complete the payment to secure your booking.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()), // Navigate to home page
                  (route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  },
  child: const Text('Cancel'),
),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(150, 50),
                  ),
                  onPressed: () {
                    if (userIdController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConfirmationPage(),
                              ),
                            );
                          });
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in both Username and Password.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Thank you for your payment.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()), // Navigate to the home page
                  (route) => false, // Remove all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}