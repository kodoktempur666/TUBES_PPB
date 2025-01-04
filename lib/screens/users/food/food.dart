import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tubes/screens/users/food/detail_food.dart';
import '../../../widgets/user/food_card.dart';

class FoodScreen extends StatelessWidget {
  final String category; // New parameter for category

  // Constructor to accept the category
  FoodScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    String title = '${category[0].toUpperCase()}${category.substring(1)} Products';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white, // Set the background color to white
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('foods')
              .where('kategori', isEqualTo: category) // Use the passed category
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var foodItems = snapshot.data!.docs;

            if (foodItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/question.svg',
                      width: 220,
                      height: 220,
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Oops, the food you're looking for is not available.",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 14, 14, 14),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Otherwise, display the list of food items
            return ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                var food = foodItems[index].data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailFoodScreen(
                        ),
                      ),
                    );
                  },
                  child: FoodCard(
                    name: food['nama_makanan'],
                    price: food['harga'],
                    seller: food['seller'],
                    description: food['deskripsi'],
                    cookingTime: food['cookingTime'],
                    stock: food['stok'],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
