import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String seller;
  final String date;
  final double totalAmount;
  final String pickedUpTime;
  final String status;
  final VoidCallback onDetails;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.seller,
    required this.date,
    required this.totalAmount,
    required this.pickedUpTime,
    required this.status,
    required this.onDetails,
  }) : super(key: key);

  String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            status == 'pending'
                ? SizedBox
                    .shrink() // Tidak menampilkan apa pun jika status adalah 'pending'
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ESTIMATED PICK UP: $pickedUpTime',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
            SizedBox(height: 8),
            Text('Status: $status', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
              'Seller: $seller',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('$date', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(formatCurrency(totalAmount),
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: onDetails,
                  child: Icon(Icons.keyboard_double_arrow_down_sharp),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
