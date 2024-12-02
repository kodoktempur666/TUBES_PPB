import 'package:flutter/material.dart';

class AddMenu extends StatelessWidget {
  const AddMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Menu')),
      body: Center(child: Text('Welcome to Seller Main Menu')),
    );
  }
}