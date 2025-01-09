import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mr_lowat_bakery/userscreens/home/favourite_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/homepage.dart';
import 'package:mr_lowat_bakery/userscreens/home/notification_page.dart';
import 'package:mr_lowat_bakery/userscreens/home/profile_menu.dart';
import 'package:mr_lowat_bakery/userscreens/home/search_page.dart';



class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

@override
Widget build(BuildContext context) {
  final controller =Get.put(NavigationController());

  return Scaffold(
    bottomNavigationBar: Obx(
      ()=> NavigationBar(
        height: 80,
        elevation:0,
        backgroundColor: Colors.orange, // Set the background color to orange
        selectedIndex: controller.selectedIndex.value,
        onDestinationSelected: (index) => controller.selectedIndex.value = index,
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
          NavigationDestination(icon: Icon(Iconsax.search_favorite), label: 'Search'),
          NavigationDestination(icon: Icon(Iconsax.heart), label: 'Favourite'),
          NavigationDestination(icon: Icon(Iconsax.notification), label: 'Notification'),
          NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    ),
    body: Obx(()=> controller.screens[controller.selectedIndex.value]),
   );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [const Homepage(),const SearchPage(),const FavouritePage(), const NotificationPage(), const ProfileMenu()];
}