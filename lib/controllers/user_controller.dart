import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data() as Map<String, dynamic>;
      }
      return null; 
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}
