import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tubes/controllers/users/detail_food_controller.dart';
import 'package:tubes/widgets/user/detail_bottom_appBar.dart';
import 'package:tubes/widgets/user/detail_name_description.dart'; // Import the new widget
import 'package:tubes/widgets/user/detail_image.dart'; // Import the DetailImage widget

class DetailFoodScreen extends StatelessWidget {
  const DetailFoodScreen({super.key}); // No parameters required now

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final DetailFoodController controller = Get.find();

    // Generate random rating between 3.0 and 5.0
    double rating = Random().nextDouble() * (5.0 - 3.0) + 3.0;

    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Details'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          // Wrap the body in SingleChildScrollView
          child: Column(
            children: [
              // Detail Image widget
              DetailImage(
                imageUrl: controller.imageUrl.value,
                placeholderSvg: 'assets/images/image-placeholder.svg',
                height: screenHeight * 0.5,
                gradientHeight: 12.0,
              ),

              const SizedBox(height: 8),

              // Food Name and Description widget
              DetailNameDescription(
                foodName: controller.foodName.value,
                description: controller.fallbackDescription,
                cookingTime: controller.cookingTime.value,
                rating: rating.toStringAsFixed(1),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DetailBottomAppBar(controller: controller),
    );
  }
}
