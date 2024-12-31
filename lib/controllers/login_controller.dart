import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<String?> login(String username, String password) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);

        
        return '/userMainMenu:${userSnapshot.docs.first.id}';
      } else {
        QuerySnapshot sellerSnapshot = await FirebaseFirestore.instance
            .collection('seller')
            .where('username', isEqualTo: username)
            .where('password', isEqualTo: password)
            .get();

        if (sellerSnapshot.docs.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setString('username', username);

          return '/sellerMainMenu:${sellerSnapshot.docs.first.id}';
        } else {
          throw Exception('Incorrect username or password');
        }
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
