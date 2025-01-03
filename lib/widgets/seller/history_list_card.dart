import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../style/color_style.dart';

class HistoryOrderCard extends StatelessWidget {
  final String status;
  final double totalAmount;
  final String buyer;
  final String date;
  final VoidCallback onDetails;

  const HistoryOrderCard(
      {required this.status,
      required this.totalAmount,
      required this.buyer,
      required this.date,
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
            Text(
              status,
              style: TextStyle(
                  color: status == 'done'
                      ? Colors.green
                      : (status == 'declined' ? Colors.red : Colors.black),
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Total Amount: ${formatCurrency(totalAmount)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(date, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8.0),
            Text(
              'Buyer: $buyer',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
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
