import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  // Sample data for food products
  final List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Classic Style Noodle',
      'price': 'Rp 20.000',
      'vendor': 'Warung mie bang ucok',
    },
    {
      'name': 'Sate Padang',
      'price': 'Rp 15.000',
      'vendor': 'Warung Sate Padang',
    },
    {
      'name': 'Sate Madura',
      'price': 'Rp 18.000',
      'vendor': 'Warung Sate Madura',
    },
    {
      'name': 'Classic Style Fried Rice',
      'price': 'Rp 25.000',
      'vendor': 'Warung mie bang ucok',
    },
  ];

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
        child: ListView.builder(
          itemCount: foodItems.length,
          itemBuilder: (context, index) {
            var food = foodItems[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Price: ${food['price']}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Vendor: ${food['vendor']}',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Add to cart or any other action
                      },
                      child: Text('Add to Cart'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
