import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/screens/users/order/order_payment.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final int price;
  final String seller;
  final int stock;
  final int cookingTime;
  final String description;

  const FoodCard({
    required this.cookingTime,
    required this.name,
    required this.price,
    required this.seller,
    required this.stock,
    required this.description,
  });

  String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<void> saveToSharedPreferences(String name, String seller) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('food_name', name);
    await prefs.setString('food_seller', seller);
  }

  Future<Map<String, dynamic>> fetchSellerDetails(String sellerName) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('seller')
        .where('nama', isEqualTo: sellerName)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }
    return {};
  }

  Future<void> showOverlay(BuildContext context) async {
    final sellerDetails = await fetchSellerDetails(seller);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Food Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: $description'),
              SizedBox(height: 8),
              Text('Cooking Time: $cookingTime mins'), // Modify if needed
              SizedBox(height: 8),
              if (sellerDetails.isNotEmpty)
                Text('Seller Address: ${sellerDetails['alamat']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

 Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // SVG Placeholder image on the left
            SvgPicture.asset(
              'assets/images/image-placeholder.svg',  // Path to your SVG file
              width: 80,  // Set the size of the placeholder image
              height: 80,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),  // Space between image and text
            // Column for text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 3),
                  Text(
                    formatCurrency(price.toDouble()),
                    style: TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Seller: $seller',
                    style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 24, 24, 24)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Stock: $stock',
                    style: TextStyle(fontSize: 12, color: const Color.fromARGB(255, 48, 48, 48)),
                  ),
                  SizedBox(height: 16),
                  if (stock == 0)
                    Text(
                      'Sold out',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: stock > 0
                            ? () async {
                                await saveToSharedPreferences(name, seller);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: Text('Buy Now', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () => showOverlay(context),
                        child: Text('More'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
