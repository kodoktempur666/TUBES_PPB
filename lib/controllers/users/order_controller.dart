import 'package:cloud_firestore/cloud_firestore.dart';

class AddOrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addOrder({
    required String username,
    required String seller,
    required List<Map<String, dynamic>> items,
    required double totalPrice,
  }) async {
    try {
      // Extract 'cookingTime' values and calculate total cooking time
      int totalCookingTime = items.fold<int>(
        0,
        (sum, item) =>
            sum + ((item['cookingTime'] as int) * (item['quantity'] as int)),
      );

      // Get the current date and time
      DateTime now = DateTime.now();
      DateTime pickupTime = now.add(Duration(minutes: totalCookingTime));

      // Format the date and time
      String date = "${now.month}-${now.day}-${now.year}";
      String time =
          "${pickupTime.hour}:${pickupTime.minute.toString().padLeft(2, '0')} ${pickupTime.hour >= 12 ? 'PM' : 'AM'}";

      // Simplify the items data
      List<Map<String, dynamic>> simplifiedItems = items.map((item) {
        return {
          'nama_makanan': item['nama_makanan'],
          'quantity': item['quantity'],
        };
      }).toList();

      // Prepare the order data
      Map<String, dynamic> orderData = {
        'date': date,
        'pickupTime': time,
        'items': simplifiedItems,
        'seller': seller,
        'buyer': username,
        'total': totalPrice,
        'status': 'pending',
      };

      // Add the order to Firestore under the 'order' collection
      await _firestore.collection('order').add(orderData);
    } catch (e) {
      rethrow; // Throw the error to handle it in the calling class or function
    }
  }
}
