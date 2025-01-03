import 'package:cloud_firestore/cloud_firestore.dart';

class FoodController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> editFood({
    required String docId,
    required String name,
    required int price,
    required int stock,
  }) async {
    try {
      await _firestore.collection('foods').doc(docId).update({
        'nama_makanan': name,
        'harga': price,
        'stok': stock,
      });
    } catch (e) {
      throw Exception('Failed to update food: $e');
    }
  }

  Future<void> deleteFood(String docId) async {
    try {
      await _firestore.collection('foods').doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete food: $e');
    }
  }
}
