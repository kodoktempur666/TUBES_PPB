import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Hashes the password with the provided salt
  String _hashPassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Check the 'users' collection first
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final user = userSnapshot.docs.first;
        String storedPasswordHash = user['password'];
        String salt = user['salt']; // Assuming the salt is stored with the user

        // Compare the hashed password
        if (storedPasswordHash == _hashPassword(password, salt)) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);

          Get.offAllNamed('/userMainMenu');
          return;
        } else {
          throw Exception('Incorrect password');
        }
      }

      // If not found in 'users', check the 'seller' collection
      QuerySnapshot sellerSnapshot = await _firestore
          .collection('seller')
          .where('username', isEqualTo: username)
          .get();

      if (sellerSnapshot.docs.isNotEmpty) {
        final seller = sellerSnapshot.docs.first;
        String storedPasswordHash = seller['password'];
        String salt =
            seller['salt']; // Assuming the salt is stored with the seller

        // Compare the hashed password
        if (storedPasswordHash == _hashPassword(password, salt)) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('username', username);

          Get.offAllNamed('/sellerMainMenu');
          return;
        } else {
          throw Exception('Incorrect password');
        }
      }

      // If neither matches, show error
      Get.snackbar(
        'Error',
        'Incorrect username or password',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
