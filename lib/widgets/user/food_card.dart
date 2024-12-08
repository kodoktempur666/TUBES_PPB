import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final int price;
  final String vendor;
  final int stock;
  
  const FoodCard({
    required this.name,
    required this.price,
    required this.vendor,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
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
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Price: Rp $price',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Vendor: $vendor',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              'Stock: $stock',
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
            SizedBox(height: 16),
            if (stock == 0)
              Text(
                'Sold out',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: stock > 0
                  ? () {                    
                    }
                  : null, 
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
