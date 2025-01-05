import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tubes/screens/users/order/order_payment.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final int price;
  final String seller;
  final int stock;
  final int cookingTime;
  final String description;
  final String imageUrl;

  const FoodCard({
    required this.cookingTime,
    required this.name,
    required this.price,
    required this.seller,
    required this.stock,
    required this.description,
    required this.imageUrl,
  });

  String toPascalCaseWithSpaces(String text) {
    List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      words[i] = words[i].substring(0, 1).toUpperCase() +
          words[i].substring(1).toLowerCase();
    }

    return words.join(' ');
  }

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
          title: const Text('Food Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Description: $description'),
              const SizedBox(height: 8),
              Text('Cooking Time: $cookingTime mins'),
              const SizedBox(height: 8),
              if (sellerDetails.isNotEmpty)
                Text('Seller Address: ${sellerDetails['alamat']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Image with rounded corners using ClipRRect
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(6), // Set the desired corner radius
              child: Container(
                width: 80,
                height: 160,
                child: FittedBox(
                  fit: BoxFit
                      .cover, // Ensures the image covers the container completely
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) {
                      // Skeleton loader while image is loading
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.grey[300],
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      // Fallback SVG image in case of error
                      return SvgPicture.asset(
                        'assets/images/image-placeholder.svg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16), // Space between image and text

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toPascalCaseWithSpaces(name),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatCurrency(price.toDouble()),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Seller: $seller',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 24, 24, 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stock: $stock',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 48, 48, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (stock == 0)
                    const Text(
                      'Sold out',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  const SizedBox(height: 16),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Buy Now',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => showOverlay(context),
                        child: const Text('More'),
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
