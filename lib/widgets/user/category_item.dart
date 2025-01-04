import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap; 

  CategoryItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Kategori
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8B4572), 
            ),
            child: icon,
          ),
          // Label Kategori
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
