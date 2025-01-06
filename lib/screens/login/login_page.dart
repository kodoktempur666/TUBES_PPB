import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tubes/controllers/login_controller.dart';
import 'package:tubes/screens/login/register_page.dart';
import 'package:tubes/style/color_style.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _loginController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Transparent background for AppBar
        elevation: 0, // Remove shadow from AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/icon.png', // Replace with your image path
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // Username TextField
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                labelStyle: TextStyle(
                    color: ColorStyle
                        .primary), // Use primary color from ColorStyle
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary,
                      width: 2.0), // Border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary,
                      width: 2.0), // Border when focused
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacing between text fields
            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    color: ColorStyle
                        .primary), // Use primary color from ColorStyle
                filled: true,
                fillColor: Colors.green.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary,
                      width: 2.0), // Border when not focused
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: ColorStyle.primary,
                      width: 2.0), // Border when focused
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20), // Spacing before the button
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                _loginController.login(username, password);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity,
                    50), // Set the width of the button to be full width
              ),
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Get.to(() => RegisterPage());
              },
              child: const Text(
                'Don\'t have an account? Register',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
