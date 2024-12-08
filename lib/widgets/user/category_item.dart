import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
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
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF8B4572), 
            ),
            child: Icon(
              icon,
              size: 32.0,
              color: Colors.white, 
            ),
          ),
          SizedBox(height: 8.0),
          // Label Kategori
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}
