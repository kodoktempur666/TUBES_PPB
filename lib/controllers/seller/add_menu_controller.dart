import 'package:cloud_firestore/cloud_firestore.dart';

class AddMenuController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addMenu({
    required String namaMakanan,
    required int harga,
    required String deskripsi,
    required String kategori,
    required int cookingTime,
    required int stok,
    required String imageUrl,
    required String seller,
  }) async {
    await _firestore.collection('foods').add({
      'nama_makanan': namaMakanan,
      'harga': harga,
      'deskripsi': deskripsi,
      'kategori': kategori,
      'cookingTime': cookingTime,
      'stok': stok,
      'imageUrl': imageUrl,
      'seller': seller,
    });
  }
}
