import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Main Menu'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Order'),
        BottomNavigationBarItem(icon: Icon(Icons.add_business), label: 'Your Menu'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: selectedIndex,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
      onTap: onItemTapped,
    );
  }
}
