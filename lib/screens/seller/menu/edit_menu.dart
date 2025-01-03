import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/screens/seller/menu/add_menu.dart';
import '../../../controllers/seller/seller_controller.dart';
import '../../../widgets/seller/edit_card.dart';
import '../../../widgets/seller/edit_form.dart';
import '../../../controllers/seller/edit_menu_controller.dart';

class FoodManagementScreen extends StatefulWidget {
  @override
  _FoodManagementScreenState createState() => _FoodManagementScreenState();
}

class _FoodManagementScreenState extends State<FoodManagementScreen> {
  final FoodController _foodController = FoodController();
  final SellerController _sellerController = SellerController();
  Map<String, dynamic>? _userData;
  String? _seller;

  @override
  void initState() {
    super.initState();
    _loadSeller();
  }

  Future<void> _loadSeller() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');

      if (username != null) {
        final data = await _sellerController.getUserData(username!);
        setState(() {
          _userData = data;
          _seller = _userData?['nama'];
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to load seller data: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Management'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddMenu()), // Navigasi ke halaman baru
              );
            },
          ),
        ],
      ),
      body: _seller == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('foods')
                  .where('seller', isEqualTo: _seller)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var foodItems = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    var food = foodItems[index].data() as Map<String, dynamic>;
                    String docId = foodItems[index].id;

                    return FoodCard(
                      name: food['nama_makanan'],
                      price: food['harga'],
                      stock: food['stok'],
                      category: food['kategori'],
                      onEdit: () {
                        _showEditForm(
                          docId: docId,
                          currentName: food['nama_makanan'],
                          currentPrice: food['harga'],
                          currentStock: food['stok'],
                        );
                      },
                      onDelete: () {
                        _foodController.deleteFood(docId);
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  void _showEditForm({
    required String docId,
    required String currentName,
    required int currentPrice,
    required int currentStock,
  }) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController priceController = TextEditingController(text: currentPrice.toString());
    TextEditingController stockController = TextEditingController(text: currentStock.toString());

    showDialog(
      context: context,
      builder: (context) {
        return EditFoodForm(
          nameController: nameController,
          priceController: priceController,
          stockController: stockController,
          onSave: () async {
            await _foodController.editFood(
              docId: docId,
              name: nameController.text,
              price: int.tryParse(priceController.text) ?? 0,
              stock: int.tryParse(stockController.text) ?? 0,
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
