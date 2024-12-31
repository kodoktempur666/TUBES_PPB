import 'package:cloud_firestore/cloud_firestore.dart';

class SellerController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserData(String username) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('seller')
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