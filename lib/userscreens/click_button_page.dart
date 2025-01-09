

import 'package:flutter/material.dart';
//import 'package:get/get.dart'; // Used for state management and navigation


class DescriptionPage extends StatelessWidget {
  const DescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cake Preferences'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Image.asset(
            'assets/cake.jpg.png', // Replace with your image asset path
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'Choose your preferences',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: [
                _buildOptionRow(context, 'Size', ['3 Inch', '5 Inch']),
                _buildOptionRow(context, 'Flavour', ['Chocolate', 'Vanilla', 'Pandan', 'Mocha']),
                _buildTopperTheme(context),
                _buildDatePicker(context),
                _buildPickupOptions(context),
                _buildOptionRow(context, 'Payment Options', ['Deposit', 'Full payment']),
                _buildAddOnOptions(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showConfirmationPopup(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Add to Cart'),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildOptionRow(BuildContext context, String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10.0,
          children: options.map((option) {
            return StatefulBuilder(
              builder: (context, setState) {
                bool isSelected = false;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: Colors.orange,
                  onSelected: (selected) {
                    setState(() {
                      isSelected = selected;
                    });
                  },
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildTopperTheme(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Topper Theme',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Insert option',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down),
              onPressed: () {
                _showTopperOptions(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _showTopperOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: const [
            ListTile(title: Text('Roses')),
            ListTile(title: Text('Stars')),
            ListTile(title: Text('Custom')),
          ],
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking Date',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: StatefulBuilder(
                builder: (context, setState) {
                  DateTime? selectedDate;
                  String formattedDate = 'Select Date';
                  return ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          selectedDate = date;
                          formattedDate = '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}';
                        });
                      }
                    },
                    child: Text(formattedDate),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildPickupOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pickup Options',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10.0,
          children: ['Self Pickup', 'Delivery'].map((option) {
            return StatefulBuilder(
              builder: (context, setState) {
                bool isSelected = false;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: Colors.orange,
                  onSelected: (selected) {
                    setState(() {
                      isSelected = selected;
                    });
                  },
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildAddOnOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add on Knife, Candle, Box',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                bool isChecked = false;
                return Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                );
              },
            ),
            const Text('Include'),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void _showConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Confirmed'),
          content: const Text('Your order has been confirmed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/cart'); // Navigate to the cart page
              },
              child: const Text('Check out your cart'),
            ),
          ],
        );
      },
    );
  }
}