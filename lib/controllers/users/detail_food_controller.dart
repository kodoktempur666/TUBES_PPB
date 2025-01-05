import 'package:get/get.dart';

class DetailFoodController extends GetxController {
  var foodName = ''.obs;
  var description = ''.obs;
  var cookingTime = 0.obs;
  var price = 0.0.obs;
  var seller = ''.obs; // Add seller to the controller
  var stock = 0.obs;  // Add stock to the controller

  // Getter for fallback description
  String get fallbackDescription =>
      description.value.isNotEmpty
          ? description.value
          : "Lorem ipsum dolor sit amet, consectetur adipiscing elit.";

  // Getter for cooking time
  String get formattedCookingTime => cookingTime.value > 0
    ? '${cookingTime.value} mins'
    : 'N/A';  // Provide fallback for 0 cooking time

  // Update food details including price, seller, and stock
  void setFoodDetails(String name, String desc, int time, double foodPrice, String foodSeller, int foodStock) {
    foodName.value = name;
    description.value = desc;
    cookingTime.value = time;
    price.value = foodPrice;
    seller.value = foodSeller;  // Set seller
    stock.value = foodStock;    // Set stock
  }
}
