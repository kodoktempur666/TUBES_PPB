import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final int price;
  final int stock;
  final String category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FoodCard({
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text('Category: $category', style: TextStyle(fontSize: 16)),
            Text('Price: ${formatCurrency(price.toDouble())}'),
            Text('Stock: $stock'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
