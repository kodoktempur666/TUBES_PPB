import 'package:flutter/material.dart';

class FoodOrderCard extends StatelessWidget {
  final String orderId;
  final String buyer;
  final String date;
  final double totalAmount;
  final VoidCallback onPickedUp;
  final VoidCallback onDetails;

  const FoodOrderCard({
    Key? key,
    required this.orderId,
    required this.buyer,
    required this.date,
    required this.totalAmount,
    required this.onPickedUp,
    required this.onDetails,
  }) : super(key: key);

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
            SizedBox(height: 8),
            Text('Buyer: $buyer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            SizedBox(height: 8),
            Text('$date', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Rp $totalAmount', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onPickedUp,
                  child: Text('Picked Up', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
