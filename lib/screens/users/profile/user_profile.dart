import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/user/user_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getUsernameFromPrefs();
  }

  Future<void> _getUsernameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username');
    });

    if (_username != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: _username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          _userData = snapshot.docs.first.data() as Map<String, dynamic>;
        });
      } else {
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

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Remove all data from SharedPreferences

    // Navigate back to the initial route (replace with your actual initial route)
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    if (_username == null || _userData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileWidget(
              nama: _userData?['nama'],
              username: _userData?['username'],
              kontak: _userData?['kontak'],
              password: _userData?['password'],
              saldo: _userData?['saldo']?.toDouble(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red, // Optional: Red color for the logout button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
