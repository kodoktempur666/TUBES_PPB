import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class RegisterController extends GetxController {
  String _hashPassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> registerUser(String name, String username, String password) async {
    String salt = _generateSalt();
    String hashedPassword = _hashPassword(password, salt);

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'username': username,
        'password': hashedPassword,
        'salt': salt,
      });
      Get.snackbar('Success', 'Registration successful');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: $e');
    }
  }

  String _generateSalt() {
    final salt = DateTime.now().millisecondsSinceEpoch.toString();
    return salt;
  }
}
