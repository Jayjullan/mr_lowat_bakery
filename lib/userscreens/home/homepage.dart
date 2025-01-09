import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/brownies_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/cart_page.dart'; // Ensure this file is correctly imported
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/burntcheesecake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/cheesetart_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/cupcake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/others_category.dart';
//import 'package:mr_lowat_bakery/userscreens/home/widgets/menu_widgets.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/cake_category.dart';
import 'package:mr_lowat_bakery/userscreens/home/Bycategories/most_ordered.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/category_widgets.dart';
import 'package:mr_lowat_bakery/userscreens/home/widgets/most_ordered_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(const MyApp());
}

class CartItem {
  final String name;
  final String price;
  final String imagePath;

  CartItem({
    required this.name,
    required this.price,
    required this.imagePath,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late User? user;
  List<CartItem> cart = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // Get current user
  }

  void _addToCart(CartItem item) {
    setState(() {
      cart.add(item); // Add item to cart
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 225, 225),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              final userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(userId: userId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('You need to log in to view the cart.')),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Image(image: AssetImage('assets/homeAds.png')),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.black, width: 1.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Discover by Category
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Discover by category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // Horizontal Scrollable Categories
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CakeCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cake.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BurntCheesecakePage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cheesecake.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const BrowniesCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/brownie.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheeseTartCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/egg-tart.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CupcakeCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/cupcake.png'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OthersCategoryPage()),
                          );
                        },
                        child: const CustomRoundedContainer(imagePath: 'assets/puffs.png'),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Most Ordered',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MostOrderedPage(collectionName: 'cakes')),
                        );
                      },
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
                          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  MenuList(collectionNames: ['cakes']),
                  SizedBox(height: 10), // Space between items
                  MenuList(collectionNames: ['burntCheesecakes']),
                  SizedBox(height: 10), // Space between items
                  MenuList(collectionNames: ['brownies']),
                  SizedBox(height: 10), // Space between items
                  MenuList(collectionNames: ['cheeseTarts']),
                  SizedBox(height: 10), // Space between items
                  MenuList(collectionNames: ['cupcakes']),
                  SizedBox(height: 10), // Space between items
                  MenuList(collectionNames: ['others']),
                ],
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
