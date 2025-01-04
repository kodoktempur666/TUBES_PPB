import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tubes/controllers/users/bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                navController.selectedIndex.value == 0
                    ? 'assets/icons/nav_home_fill.svg'
                    : 'assets/icons/nav_home_outline.svg',
                semanticsLabel: 'Home',
                height: 25,
                width: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                navController.selectedIndex.value == 1
                    ? 'assets/icons/nav_order_fill.svg'
                    : 'assets/icons/nav_order_outline.svg',
                semanticsLabel: 'Order',
                height: 25,
                width: 25,
              ),
              label: 'Order',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                navController.selectedIndex.value == 2
                    ? 'assets/icons/nav_profile_fill.svg'
                    : 'assets/icons/nav_profile_outline.svg',
                semanticsLabel: 'Profile',
                height: 25,
                width: 25,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: navController.selectedIndex.value,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            navController.changeIndex(index);
          },
        ));
  }
}
