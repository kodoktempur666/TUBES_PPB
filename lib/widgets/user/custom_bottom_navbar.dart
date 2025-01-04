import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/nav_home.svg',
              semanticsLabel: 'Home',
              height: 25,
              width: 25,
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/nav_order.svg',
              semanticsLabel: 'Order',
              height: 25,
              width: 25,
            ),
            label: 'Order'),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/nav_profile.svg',
              semanticsLabel: 'Profile',
              height: 25,
              width: 25,
            ),
            label: 'Profile'),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.black,
      onTap: onItemTapped,
    );
  }
}
