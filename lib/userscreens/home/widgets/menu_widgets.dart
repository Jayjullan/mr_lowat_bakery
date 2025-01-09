import 'package:flutter/material.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/description_page.dart';

class MenuWidgets extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final VoidCallback onPressed; // Callback for external actions (e.g., add to cart)

  const MenuWidgets({
    super.key,
    required this.imagePath,
    required this.name,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 200,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 246, 244), // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 6.0, // How much the shadow is blurred
            spreadRadius: 2.0, // How much the shadow spreads
            offset: const Offset(4.0, 4.0), // Shadow offset
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ), // Rounded top corners
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                    },
                  )
                : Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
                    },
                  ),
          ),
          const SizedBox(height: 10),
          // Name, Price, and Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name and Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: 1, // Restrict to one line
                        overflow: TextOverflow.ellipsis, // Add ellipsis for long text
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'RM $price',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                // Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DescriptionPage(
                          imagePath: imagePath,
                          name: name,
                          price: price,
                          onAddToCart: onPressed, // Pass the external callback
                        ),
                      ),
                    );
                  }, // Call the external callback (onPressed)
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(6),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
