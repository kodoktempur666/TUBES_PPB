import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../../../../widgets_user/user_profile.dart'; // Import ProfileWidget yang sudah dibuat sebelumnya

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _username; // Username yang diambil dari SharedPreferences
  Map<String, dynamic>? _userData; // Data pengguna dari Firestore

  @override
  void initState() {
    super.initState();
    _getUsernameFromPrefs(); // Ambil username dari SharedPreferences saat halaman dimuat
  }

  // Ambil username dari SharedPreferences
  Future<void> _getUsernameFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username'); // Simpan username yang diambil dari SharedPreferences
    });

    if (_username != null) {
      _fetchUserData(); // Jika username ada, ambil data pengguna dari Firestore
    }
  }

  // Ambil data pengguna dari Firestore berdasarkan username
  Future<void> _fetchUserData() async {
    try {
      // Ambil data pengguna berdasarkan username dari Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
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

  // Tampilkan dialog error jika ada masalah
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
    // Menunggu hingga username dan data pengguna diambil
    if (_username == null || _userData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Center(child: CircularProgressIndicator()), // Menampilkan loading indicator
      );
    }

    // Menampilkan halaman profil jika data sudah ada
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProfileWidget(
          nama: _userData?['nama'],
          username: _userData?['username'],
          kontak: _userData?['kontak'],
          password: _userData?['password'],
          saldo: _userData?['saldo']?.toDouble(), // pastikan balance adalah double
        ),
      ),
    );
  }
}
