import 'package:flutter/material.dart';
import 'package:tubes/controllers/login_controller.dart';
import 'package:tubes/style/color_style.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  void _login() async {
    // For dev only!!
    String username = "johan123";
    String password = "123";

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
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Padding inside the form container
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                    borderSide: const BorderSide(
                        color: Colors.grey, width: 0.5), // Subtle grey border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Keep the corners rounded when focused
                    borderSide: const BorderSide(
                        color: ColorStyle.primary,
                        width: 0.5), // Subtle grey border on focus
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 209, 209, 209),
                        width: 0.5), // Subtle grey border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        12.0), // Keep the corners rounded when focused
                    borderSide: const BorderSide(
                        color: ColorStyle.primary,
                        width: 1.0), // Subtle grey border on focus
                  ),
                ),
                obscureText: true,
              ),

              const SizedBox(height: 20),
              // Expanded button with border radius and color
              SizedBox(
                width: double.infinity, // Make the button take the full width
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyle
                        .primary, // Use the primary color from ColorStyle
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Button border radius
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
