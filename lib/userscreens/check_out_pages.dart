import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mr_lowat_bakery/userscreens/payment_options_page.dart';

class ProductInfo extends StatelessWidget {
  final String imagePath;
  final String name;
  final double price;
  final String flavour;
  final String size;
  final bool addOns;
  final bool isDelivery;
  final DateTime bookingDate;
  final String paymentOption;
  final String pickupOption;

  const ProductInfo({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.flavour,
    required this.size,
    required this.addOns,
    required this.isDelivery,
    required this.bookingDate,
    required this.paymentOption,
    required this.pickupOption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 80),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                'RM ${price.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _buildDetailRow('Flavour', flavour),
              _buildDetailRow('Size', size),
              _buildDetailRow('Booking Date', DateFormat('yyyy-MM-dd').format(bookingDate)),
              _buildDetailRow('Payment', paymentOption),
              _buildDetailRow('Pickup', pickupOption),
              const Divider(thickness: 1), // Divider *between* sections
              _buildDetailRow('Add-ons', addOns ? "RM 5.00" : "Not Included"),
              _buildDetailRow('Delivery', isDelivery ? "RM 5.00" : "Not Included"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}


class CheckoutPage extends StatelessWidget {
  final String userId;
  final String cartItemId;

  const CheckoutPage({super.key, required this.userId, required this.cartItemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .doc(cartItemId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Cart item not found.'));
          }

          final cartItem = snapshot.data!.data() as Map<String, dynamic>;

          DateTime bookingDate = DateTime.now();
          if (cartItem.containsKey('bookingDate')) {
            final bookingData = cartItem['bookingDate'];
            if (bookingData != null) {
              if (bookingData is Timestamp) {
                bookingDate = bookingData.toDate();
              } else if (bookingData is String) {
                try {
                  bookingDate = DateTime.parse(bookingData);
                } catch (e) {
                  print("Error parsing bookingDate: $e");
                }
              } else {
                print("bookingDate is of unexpected type: ${bookingData.runtimeType}");
              }
            } else {
              print("bookingDate is null");
            }
          } else {
            print("bookingDate field is missing in document");
          }

          double price = 0.0;
          if (cartItem.containsKey('price')) {
            final priceData = cartItem['price'];
            if (priceData is num) {
              price = priceData.toDouble();
            } else if (priceData is String) {
              price = double.tryParse(priceData) ?? 0.0;
            } else {
              print('Unexpected price data type: ${priceData.runtimeType}');
            }
          } else {
            print("price field is missing");
          }

          bool addOns = false;
          if (cartItem.containsKey('addOns')) {
            final addOnsData = cartItem['addOns'];
            if (addOnsData is bool) {
              addOns = addOnsData;
            } else if (addOnsData is String) {
              addOns = addOnsData.toLowerCase() == 'true';
            } else {
              print('Unexpected addOns data type: ${addOnsData.runtimeType}');
            }
          } else {
            print("addOns field is missing");
          }

          bool isDelivery = false;
          if (cartItem.containsKey('pickupOption')) {
            isDelivery = cartItem['pickupOption'] == 'Delivery';
          } else {
            print("pickupOption field is missing");
          }

          print("Addons value before adding price: $addOns");
          print("Delivery value before adding price: $isDelivery");

          if (addOns) {
            price += 5;
            print("Price with addons: RM ${price.toStringAsFixed(2)}");
          }

          if (isDelivery) {
            price += 5.00;
            print("Price with delivery: RM ${price.toStringAsFixed(2)}");
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProductInfo(
                      imagePath: cartItem['imagePath'] ?? '',
                      name: cartItem['name'] ?? '',
                      price: price,
                      flavour: cartItem['flavour'] ?? '',
                      size: cartItem['size'] ?? '',
                      paymentOption: cartItem['paymentOption'] ?? '',
                      pickupOption: cartItem['pickupOption'] ?? '',
                      bookingDate: bookingDate,
                      addOns: addOns,
                      isDelivery: isDelivery,
                    ),
                  ),
                ),
                const Spacer(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'RM ${price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentOptionsPage(
                          isDelivery: true, // or false, depending on your logic
                          addOns: addOns, // replace with your actual add-ons list or data
                          price: price, // replace with the actual price
                          cartItemId:cartItemId, // replace with the actual cart item ID
                          userId: userId, // replace with the actual user ID
                        ),
                      ),
                     );
                   },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Center(child: Text('Proceed To Payment')),
                ),
              ],
            ),
          );
     }, // Closing brace for FutureBuilder
      ), // Closing brace for Scaffold
    );
  }
}