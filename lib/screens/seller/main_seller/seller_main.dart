import 'package:flutter/material.dart';
import '../menu/add_menu.dart';
import '../order/food_order.dart';
import '../profile/seller_profile.dart';
import '../../../widgets/seller/bottom_navbar.dart';
import '../../../controllers/seller_controller.dart';
import '../../../style/color_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SellerMenuPage extends StatefulWidget {
  @override
  _SellerMenuPageState createState() => _SellerMenuPageState();
}

class _SellerMenuPageState extends State<SellerMenuPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[
    SellerMenuScreen(),
    FoodOrder(),
    AddMenu(),
    SellerProfile(),
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

class SellerMenuScreen extends StatefulWidget {
  @override
  _SellerMenuScreenState createState() => _SellerMenuScreenState();
}

class _SellerMenuScreenState extends State<SellerMenuScreen> {
  String? _username;
  Map<String, dynamic>? _userData;

  final SellerController _sellerController = SellerController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); 
  }

  // mengambil username dari shared_preferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username =
          prefs.getString('username'); 

      if (_username != null) {
        final data = await _sellerController.getUserData(_username!);
        setState(() {
          _userData = data;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to load user data: $e');
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
        ? Center(
            child:
                CircularProgressIndicator()) 
        : SingleChildScrollView(
            child: Column(
              children: [
                // Header Container
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: ColorStyle.primary,
                  child: Column(
                    children: [
                      // Welcome Text and Balance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hi, ${_userData?['nama'] ?? 'Guest'}\nWelcome to Back!', 
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                      // Search Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Balance',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(
                                'Rp ${_userData?['saldo'] ?? 0}', 
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Active Order',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(
                                '1', 
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Order List',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )))
              ],
            ),
          );
  }
}
