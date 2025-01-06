import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tubes/controllers/users/detail_food_controller.dart';
import 'package:tubes/screens/users/food/detail_food.dart';
import '../../../widgets/user/food_card.dart';

class FoodAllScreen extends StatefulWidget {
  @override
  _FoodAllScreenState createState() => _FoodAllScreenState();
}

class _FoodAllScreenState extends State<FoodAllScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<DocumentSnapshot> _foodItems = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _fetchFoodItems();
  }

  Future<void> _fetchFoodItems() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    Query query =
        _firestore.collection('foods').orderBy('nama_makanan').limit(10);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    try {
      QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
        _foodItems.addAll(snapshot.docs);
      } else {
        _hasMore = false;
      }
    } catch (e) {
      debugPrint('Error fetching food items: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'All Food Products',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!_isLoading &&
                _hasMore &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _fetchFoodItems();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: _foodItems.length + (_hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _foodItems.length) {
                // Show loading indicator at the bottom
                return const Center(child: CircularProgressIndicator());
              }

              var food = _foodItems[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  final controller = Get.put(DetailFoodController());
                  controller.setFoodDetails(
                    food['nama_makanan'],
                    food['deskripsi'],
                    food['cookingTime'],
                    food['harga'].toDouble(),
                    food['seller'],
                    food['stok'],
                    food['imageUrl'],
                  );
                  Get.to(() => DetailFoodScreen());
                },
                child: FoodCard(
                  name: food['nama_makanan'],
                  price: food['harga'],
                  seller: food['seller'],
                  description: food['deskripsi'],
                  cookingTime: food['cookingTime'],
                  stock: food['stok'],
                  imageUrl: food['imageUrl'],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
