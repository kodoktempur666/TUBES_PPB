import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  String username = ''; // Inisialisasi username

  @override
  void initState() {
    super.initState();
    _getUsername();  // Ambil username saat halaman dimuat
  }

  // Ambil username dari shared_preferences
  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? 'Guest';  // Default 'Guest' jika null
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Menu')),
      body: Center(
        child: Text(
          'Hi, $username\nWelcome to our store!',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
