import 'package:flutter/material.dart';
import 'package:tubes/controllers/login_controller.dart';

import '../../style/color_style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    try {
      String? route = await _authController.login(username, password);
      if (route != null) {
        List<String> routeParts = route.split(':');
        String routeName = routeParts[0];
        String userId = routeParts[1];

        Navigator.pushReplacementNamed(context, routeName, arguments: userId);
      }
    } catch (e) {
      _showErrorDialog(e.toString());
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
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Membuat latar belakang transparan
        elevation: 0, // Menghilangkan shadow pada AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/icon.png', // Ganti dengan path gambar Anda
              width: 200, 
              height: 200, 
              fit: BoxFit.contain, 
            ),
            SizedBox(height: 20), 
            // Form login
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(color: ColorStyle.primary), 
                filled: true, 
                fillColor: Colors.green.shade50, 
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), 
                  borderSide: BorderSide.none, 
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary, width: 2.0), // Border aktif
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary,
                      width: 2.0), // Border saat fokus
                ),
              ),
            ),
            SizedBox(height: 20), // Spasi antara TextField
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: ColorStyle.primary), // Warna label teks
                filled: true, // Mengaktifkan latar belakang
                fillColor: Colors.green.shade50, // Warna latar belakang
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Membuat sudut melengkung
                  borderSide: BorderSide.none, // Hilangkan garis border
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary, width: 2.0), // Border aktif
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary,
                      width: 2.0), // Border saat fokus
                ),
              ),
              obscureText: true,
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Mengatur warna latar belakang tombol
                minimumSize: Size(double.infinity, 50), // Mengatur lebar tombol
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
