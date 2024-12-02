import 'package:flutter/material.dart';

class FoodOrder extends StatelessWidget {
  const FoodOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Order Menu')),
      body: Center(child: Text('Welcome to Seller Main Menu')),
    );
  }
}