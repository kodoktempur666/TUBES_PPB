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

  Widget _buildPromotionCard(String imagePath, String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
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
                // Promotion Cards
                SizedBox(height: 16.0), // Spacing after header
                _buildPromotionCard(
                  'assets/images/promo1.png', // Path gambar
                  'Special Offer',
                  'Get 50% off for the first purchase!',
                ),
                SizedBox(height: 16.0), // Spacing between cards
                _buildPromotionCard(
                  'assets/images/promo2.png', // Path gambar
                  'New Arrival',
                  'Check out our newest products!',
                ),
                SizedBox(height: 16.0),
                _buildPromotionCard(
                  'assets/images/promo3.png', // Path gambar
                  'Easy Payment',
                  'Pay with ease and convenience!',
                ),
                SizedBox(height: 16.0),
              ],
            ),
          );
  }
}
