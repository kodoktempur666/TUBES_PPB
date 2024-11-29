import 'package:flutter/material.dart';
import 'package:tubes/features/screens/food_screen/food.dart';
import '../../../widgets/category_item.dart';
import '../food_screen/preference_page.dart';
import '../order/order_page.dart';
import 'profile_page.dart';
import '../../../widgets/custom_bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan berdasarkan index
  List<Widget> _pages = <Widget>[
    MainMenuScreen(),
    OrderScreen(),
    ProfilePage(),  // Default username empty
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

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  String username = '';  // Inisialisasi username

  @override
  void initState() {
    super.initState();
    _getUsername(); // Ambil username saat halaman dimuat
  }

  // Fungsi untuk mengambil username dari shared_preferences
  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest'; // Default 'Guest' jika null
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                      'Hi, $username\nWelcome to our store!', // Menampilkan username
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Column(
                      children: [
                        Text('Balance', style: TextStyle(color: Colors.white)),
                        Text('Rp 95.000', style: TextStyle(color: Colors.white)),
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
                          MaterialPageRoute(builder: (context) => FoodScreen()),
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
