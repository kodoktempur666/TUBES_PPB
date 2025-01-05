import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tubes/controllers/users/detail_food_controller.dart';
import 'package:tubes/screens/users/order/order_payment.dart';
import 'package:tubes/style/color_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBottomAppBar extends StatelessWidget {
  const DetailBottomAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  final DetailFoodController controller;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price Section with Flexible
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Price",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                  const SizedBox(height: 1),
                  Text(
                    formatCurrency(controller
                        .price.value), // Use the formatCurrency function here
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                    overflow: TextOverflow.ellipsis, // Prevent overflow
                  ),
                ],
              ),
            ),

            // Order Now Button
            ElevatedButton(
              onPressed: () async {
                // Save the necessary data
                final prefs = await SharedPreferences.getInstance();

                // Save food data
                await prefs.setString(
                    'food_name', controller.foodName.value); // Save food name
                await prefs.setString(
                    'food_seller', controller.seller.value); // Save seller name
                await prefs.setDouble(
                    'food_price', controller.price.value); // Save price

                // Navigate to PaymentScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyle
                    .button1, // You can replace with your custom color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
              ),
              child: const Text(
                'Order Now',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
