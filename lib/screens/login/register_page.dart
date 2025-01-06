import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tubes/controllers/register_controller.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegisterController _registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _RegisterAction(
                      name: _nameController.text,
                      username: _usernameController.text,
                      password: _passwordController.text,
                      registerController: _registerController,
                    ).register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Register',
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

class _RegisterAction {
  final String name;
  final String username;
  final String password;
  final RegisterController registerController;

  _RegisterAction({
    required this.name,
    required this.username,
    required this.password,
    required this.registerController,
  });

  Future<void> register() async {
    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    try {
      await registerController.registerUser(name, username, password);
      Get.offAllNamed('/');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Registration failed. Please try again.');
    }
  }
}
