import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tubes/features/screens/users/food_screen/food.dart';
import '../../../../widgets_user/category_item.dart';
import '../menu/add_menu.dart';
import '../order/food_order.dart';
import '../profile/seller_profile.dart';
import '../../../../widgets_seller/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class SellerMenuPage extends StatefulWidget {
  @override
  _SellerMenuPageState createState() => _SellerMenuPageState();
}

class _SellerMenuPageState extends State<SellerMenuPage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan berdasarkan index
  List<Widget> _pages = <Widget>[
    SellerMenuScreen(),
    FoodOrder(),
    AddMenu(),
    SellerProfile(), // Default username empty
  ];

  // Fungsi untuk mengubah index halaman saat item bottom navigation dipilih
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Menampilkan halaman sesuai dengan index
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
  String username = '';
  String? _username;
  Map<String, dynamic>? _userData; // Inisialisasi username

  @override
  void initState() {
    super.initState();
    _getUsername(); // Ambil username saat halaman dimuat
  }

  // Fungsi untuk mengambil username dari shared_preferences
  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Guest';
    });
    if (_username != null) {
      await _fetchUserData(); // Panggil fetch setelah username siap
    }
  }

  Future<void> _fetchUserData() async {
    try {
      // Ambil data pengguna berdasarkan username dari Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('seller')
          .where('username', isEqualTo: _username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _userData = snapshot.docs.first.data() as Map<String, dynamic>;
        });
      } else {
        // Jika tidak ada data, beri notifikasi atau tampilkan pesan error
        _showErrorDialog('User not found.');
      }
    } catch (e) {
      _showErrorDialog('Error fetching user data: $e');
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
                CircularProgressIndicator()) // Tampilkan loading jika data belum siap
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
                            'Hi, ${_userData?['nama'] ?? 'Guest'}\nWelcome to our store!', // Menampilkan username
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Column(
                            children: [
                              Text('Balance',
                                  style: TextStyle(color: Colors.white)),
                              Text(
                                'Rp ${_userData?['saldo'] ?? 0}', // Gunakan default 0 jika null
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),

                      // Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CategoryItem(
                            icon: Icons.liquor,
                            label: 'Beverage',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodScreen()),
                              );
                            },
                          ),
                          CategoryItem(
                            icon: Icons.fastfood,
                            label: 'Food',
                            onTap: () {
                              print('Pizza clicked');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
