import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tubes/controllers/users/bottom_nav_controller.dart';
import 'package:tubes/screens/users/food/all_food.dart';
import 'package:tubes/screens/users/food/food.dart';
import '../../../widgets/user/category_item.dart';
import '../order/order_page.dart';
import '../profile/user_profile.dart';
import '../../../widgets/user/custom_bottom_navbar.dart';
import '../../../controllers/users/user_controller.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  final BottomNavController navController = Get.put(BottomNavController());

  List<Widget> _pages = <Widget>[
    MainMenuScreen(),
    const OrderScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Use navController.selectedIndex to dynamically switch pages
        return _pages[navController.selectedIndex.value];
      }),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String? _username;
  Map<String, dynamic>? _userData;

  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username');

      if (_username != null) {
        final data = await _userController.getUserData(_username!);
        setState(() {
          _userData = data;
        });
      }
    } catch (e) {
      _showErrorDialog('Error loading user data: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userData == null
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
            slivers: [
              // SliverAppBar for sticky header
              SliverAppBar(
                expandedHeight: 125, // Adjust height of the expanded AppBar
                pinned: true, // Keeps the app bar pinned when scrolling
                backgroundColor: const Color(0xFF8B4572),
                flexibleSpace: FlexibleSpaceBar(
                  title:
                      Container(), // This is kept empty to avoid default title behavior
                  background: Padding(
                    padding: const EdgeInsets.only(
                        top: 50.0, left: 16.0, right: 16.0),
                    child: Column(
                      children: [
                        // Row for text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hi, ${_userData?['nama'] ?? 'Guest'},',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Balance',
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                  formatCurrency(_userData?['saldo'] ?? 0),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0), // Space for search bar
                        // Search Bar inside the AppBar, constrained properly
                        Container(
                          height: 40.0,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search...',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 16.0),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                  ),
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // SliverToBoxAdapter for categories and other content (outside the SliverAppBar)
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color(0xFF8B4572),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      CategoryItem(
                        icon: Image.asset('assets/icons/cat_food.png',
                            width: 56, height: 56),
                        label: 'Food',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodScreen(category: 'food')),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: Image.asset('assets/icons/cat_beverage.png',
                            width: 56, height: 56),
                        label: 'Beverage',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodScreen(category: 'beverage')),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: Image.asset('assets/icons/cat_noodle.png',
                            width: 56, height: 56),
                        label: 'Noodle',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodScreen(category: 'noodle')),
                          );
                        },
                      ),
                      CategoryItem(
                        icon: Image.asset('assets/icons/cat_beef.png',
                            width: 56, height: 56),
                        label: 'Beef',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FoodScreen(category: 'beef')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Promotion Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/images/banner_content.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => FoodAllScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: const Text('Order Now',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Food Mood Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/images/banner_food_mood.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 8.0,
                        left: 15,
                        right: 15,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDACB7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            fixedSize: const Size(double.infinity, 36),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text('Tap and Explore',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
