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
        BottomNavigationBarItem(icon: Icon(Icons.gif_box), label: 'Order'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add Menu'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: selectedIndex,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
      onTap: onItemTapped,
    );
  }
}
