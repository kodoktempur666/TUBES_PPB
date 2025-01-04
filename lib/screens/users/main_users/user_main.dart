import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes/screens/users/food/beverage.dart';
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
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[
    MainMenuScreen(),
    OrderScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
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
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Container
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Color(0xFF8B4572),
                  child: Column(
                    children: [
                      // Welcome Text and Balance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hi, ${_userData?['nama'] ?? 'Guest'}\nWelcome to our store!',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Column(
                            children: [
                              Text('Balance',
                                  style: TextStyle(color: Colors.white)),
                              Text(
                                formatCurrency(_userData?['saldo'] ?? 0),
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                      // Search Bar
                      Container(
                        height: 40.0,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                                  border: InputBorder
                                      .none, // Removes the default border
                                  hintText: 'Search...', // Placeholder text
                                  hintStyle: TextStyle(
                                    color: Colors
                                        .grey, // Faded light gray color for hint text
                                    fontSize: 16.0, // Adjust the size as needed
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.0), // Vertical alignment
                                ),
                                style: TextStyle(
                                  fontSize: 16.0, // Text size for input
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 16.0),

                      // Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CategoryItem(
                            icon: Icons.fastfood,
                            label: 'Food',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodScreen()),
                              );
                            },
                          ),
                          CategoryItem(
                            icon: Icons.liquor,
                            label: 'Beverage',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BeverageScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Promotion Banner
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Stack(
                    children: [
                      // Background Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            16.0), // Rounded corners for the banner
                        child: Image.asset(
                          'assets/images/banner_content.png',
                          fit: BoxFit
                              .cover, // Ensures the image scales nicely to the container
                          width: double
                              .infinity, // Takes up full width of the parent
                        ),
                      ),

                      // Order Now Button
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add navigation or functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Purple text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                          child: const Text('Order Now', style: TextStyle(fontSize: 14),),
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
