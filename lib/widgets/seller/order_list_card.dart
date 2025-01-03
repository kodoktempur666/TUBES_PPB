import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../style/color_style.dart';

class OrderCard extends StatelessWidget {
  final String status;
  final double totalAmount;
  final String username;
  final String date;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onDetails;

  const OrderCard(
      {required this.status,
      required this.totalAmount,
      required this.username,
      required this.date,
      required this.onAccept,
      required this.onDecline,
      required this.onDetails});

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
            SizedBox(height: 8.0),
            Text(status,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('Total Amount: ${formatCurrency(totalAmount)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(date, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8.0),
            Text('Ordered by: $username', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onDecline,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900]),
                  child: Text('Decline', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[900]),
                  child: Text('Accept', style: TextStyle(color: Colors.white)),
                ),
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
