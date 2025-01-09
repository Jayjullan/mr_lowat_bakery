import 'package:flutter/material.dart';

class PreferencesOverlay extends StatefulWidget {
  final String name;
  final String price;
  final Function(Map<String, String>) onAddToCart;

  const PreferencesOverlay({
    super.key,
    required this.name,
    required this.price,
    required this.onAddToCart,
  });

  @override
  _PreferencesOverlayState createState() => _PreferencesOverlayState();
}

class _PreferencesOverlayState extends State<PreferencesOverlay> {
  String selectedSize = '3 Inch';
  String selectedFlavour = 'Chocolate';
  String selectedPickupOption = 'Self Pickup';
  String selectedPaymentOption = 'Deposit';
  String topperTheme = '';
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text("Choose your preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // Size Options
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Size:"),
                Row(
                  children: ['3 Inch', '5 Inch'].map((size) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(size),
                        selected: selectedSize == size,
                        onSelected: (selected) {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Flavour Options
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Flavour:"),
                Row(
                  children: ['Chocolate', 'Pandan', 'Vanilla', 'Mocha'].map((flavour) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(flavour),
                        selected: selectedFlavour == flavour,
                        onSelected: (selected) {
                          setState(() {
                            selectedFlavour = flavour;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Topper Theme
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Topper Theme"),
              onChanged: (value) {
                topperTheme = value;
              },
            ),

            // Booking Date
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Booking Date:"),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),

            // Pickup Options
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pickup Options:"),
                Row(
                  children: ['Self Pickup', 'Delivery'].map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(option),
                        selected: selectedPickupOption == option,
                        onSelected: (selected) {
                          setState(() {
                            selectedPickupOption = option;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Payment Options
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Payment Options:"),
                Row(
                  children: ['Deposit', 'Full payment'].map((option) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(option),
                        selected: selectedPaymentOption == option,
                        onSelected: (selected) {
                          setState(() {
                            selectedPaymentOption = option;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Add to Cart Button
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Map<String, String> selectedOptions = {
                  'size': selectedSize,
                  'flavour': selectedFlavour,
                  'pickupOption': selectedPickupOption,
                  'paymentOption': selectedPaymentOption,
                  'topperTheme': topperTheme,
                  'date': selectedDate != null ? selectedDate.toString() : '',
                };
                widget.onAddToCart(selectedOptions);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text("Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
