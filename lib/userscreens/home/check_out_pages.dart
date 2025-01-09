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
            child: Image.network(
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
              Flexible(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
              _buildDetailRow('Delivery', isDelivery ? "RM 10.00" : "Not Included"),
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
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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

          final bookingDate = _parseBookingDate(cartItem);
          final price = _calculatePrice(cartItem);
          final addOns = cartItem['addOns'] ?? false;
          final isDelivery = cartItem['pickupOption'] == 'Delivery';

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
        },
      ),
    );
  }

  DateTime _parseBookingDate(Map<String, dynamic> cartItem) {
    if (cartItem.containsKey('bookingDate')) {
      final bookingData = cartItem['bookingDate'];
      if (bookingData is Timestamp) return bookingData.toDate();
      if (bookingData is String) return DateTime.tryParse(bookingData) ?? DateTime.now();
    }
    return DateTime.now();
  }

  double _calculatePrice(Map<String, dynamic> cartItem) {
    double price = cartItem['price'] ?? 0.0;
    if (cartItem['addOns'] == true) price += 5;
    if (cartItem['pickupOption'] == 'Delivery') price += 5;
    return price;
  }
}
