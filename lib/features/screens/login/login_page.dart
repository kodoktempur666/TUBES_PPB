import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Cek di koleksi 'users'
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Ambil ID dokumen pengguna yang ditemukan
        String userId = userSnapshot.docs.first.id;

        // Simpan username ke shared_preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        // Navigasi ke '/userMainMenu' dengan mengirimkan ID pengguna
        Navigator.pushReplacementNamed(context, '/userMainMenu', arguments: userId);
      } else {
        // Jika tidak ditemukan, cek di koleksi 'sellers'
        QuerySnapshot sellerSnapshot = await FirebaseFirestore.instance
            .collection('seller')
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .get();

        if (sellerSnapshot.docs.isNotEmpty) {
          // Simpan username penjual ke shared_preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);

          Navigator.pushReplacementNamed(context, '/sellerMainMenu');
        } else {
          _showErrorDialog('Incorrect username or password');
        }
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Login Failed'),
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
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
