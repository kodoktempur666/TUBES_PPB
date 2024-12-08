import 'package:flutter/material.dart';

class SellerProfile extends StatelessWidget {
  const SellerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('seller profile Menu')),
      body: Center(child: Text('Welcome to Seller Main Menu')),
    );
  }
}