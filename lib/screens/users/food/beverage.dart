import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../widgets/user/food_card.dart'; 
class BeverageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Food Products',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('foods')
              .where('kategori', isEqualTo: 'beverage')
              // .where('stok', isGreaterThan: 0) 
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var foodItems = snapshot.data!.docs;

            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                var food = foodItems[index].data() as Map<String, dynamic>;
                return FoodCard(
                  name: food['nama_makanan'],
                  price: food['harga'],
                  seller: food['seller'],
                  cookingTime: food['cookingTime'],
                  description: food['deskripsi'],
                  stock: food['stok'],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
