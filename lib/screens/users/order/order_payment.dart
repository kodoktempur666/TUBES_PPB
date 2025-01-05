import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/users/user_controller.dart';
import '../../../controllers/users/order_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../widgets/user/order_payment_body.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserController _userController = UserController();
  final AddOrderController _addOrderController = AddOrderController();

  String _username = '';
  String _seller = '';
  List<Map<String, dynamic>> foodItems = [];
  List<Map<String, dynamic>> selectedItems = [];
  Map<String, dynamic>? _userData;
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
    _loadUserData();
    _loadFirstItem();
  }

  Future<void> _loadFirstItem() async {
    final prefs = await SharedPreferences.getInstance();
    String foodName = prefs.getString('food_name') ?? 'Unknown';
    String seller = prefs.getString('food_seller') ?? 'Unknown';

    QuerySnapshot querySnapshot = await _firestore
        .collection('foods')
        .where('seller', isEqualTo: seller)
        .get();

    if (foodName != 'Unknown' && seller != 'Unknown') {
      var foodItem = querySnapshot.docs.firstWhere(
        (doc) => doc['nama_makanan'] == foodName,
      );
      _addMenuItem({
        'nama_makanan': foodItem['nama_makanan'] ?? '',
        'harga': foodItem['harga'] ?? 0,
        'deskripsi': foodItem['deskripsi'] ?? '',
        'seller': foodItem['seller'] ?? '',
        'stok': foodItem['stok'] ?? 0,
        'cookingTime': foodItem['cookingTime'] ?? 0,
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? '';
      _seller = prefs.getString('food_seller') ?? '';

      if (_username.isNotEmpty) {
        final data = await _userController.getUserData(_username);
        setState(() {
          _userData = data;
        });
      }
    } catch (e) {
      _showErrorDialog('Error loading user data: $e');
    }
  }

  Future<void> _loadFoodItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String seller = prefs.getString('food_seller') ?? 'Unknown';
      QuerySnapshot querySnapshot = await _firestore
          .collection('foods')
          .where('seller', isEqualTo: seller)
          .get();

      setState(() {
        foodItems = querySnapshot.docs.map((doc) {
          return {
            'nama_makanan': doc['nama_makanan'] ?? '',
            'harga': doc['harga'] ?? 0,
            'deskripsi': doc['deskripsi'] ?? '',
            'seller': doc['seller'] ?? '',
            'stok': doc['stok'] ?? 0,
            'cookingTime': doc['cookingTime'] ?? 0,
          };
        }).toList();
      });
    } catch (e) {
      _showErrorDialog('Error loading food items: $e');
    }
  }

  Future<void> _processPayment() async {
    try {
      String username = _username; // Username dari SharedPreferences
      double userBalance = (_userData?['saldo'] ?? 0).toDouble();

      if (userBalance >= totalPrice) {
        // Kurangi saldo pengguna di Firestore
        QuerySnapshot querySnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: username)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Dapatkan ID dokumen pengguna
          String userId = querySnapshot.docs.first.id;

          // Perbarui saldo di Firestore
          await _firestore
              .collection('users')
              .doc(userId)
              .update({'saldo': userBalance - totalPrice});
        }

        // Kurangi stok makanan
        for (var item in selectedItems) {
          QuerySnapshot foodQuery = await _firestore
              .collection('foods')
              .where('nama_makanan', isEqualTo: item['nama_makanan'])
              .where('seller', isEqualTo: item['seller'])
              .get();

          if (foodQuery.docs.isNotEmpty) {
            String foodId = foodQuery.docs.first.id;
            int currentStock = foodQuery.docs.first['stok'];

            if (currentStock >= item['quantity']) {
              // Perbarui stok di Firestore
              await _firestore.collection('foods').doc(foodId).update({
                'stok': currentStock - item['quantity'],
              });
            } else {
              _showErrorDialog(
                'Stock for ${item['nama_makanan']} is not sufficient.',
              );
              return; // Hentikan pembayaran jika stok tidak mencukupi
            }
          }
        }

        // Tambahkan pesanan ke koleksi 'order'
        await _addOrderController.addOrder(
          username: username,
          seller: _seller,
          items: selectedItems,
          totalPrice: totalPrice,
        );

        setState(() {
          selectedItems.clear();
          totalPrice = 0;
        });

        _showSuccessDialog('Payment Successful!');
      } else {
        _showErrorDialog('Insufficient balance to complete the payment.');
      }
    } catch (e) {
      _showErrorDialog('Error processing payment: $e');
    }
  }

  void _addMenuItem(Map<String, dynamic> foodItem) {
    setState(() {
      bool itemExists = false;
      for (var item in selectedItems) {
        if (item['nama_makanan'] == foodItem['nama_makanan']) {
          item['quantity'] += 1;
          totalPrice += (foodItem['harga'] as num).toDouble();
          itemExists = true;
          break;
        }
      }

      if (!itemExists) {
        selectedItems.add({
          ...foodItem,
          'quantity': 1,
        });
        totalPrice += (foodItem['harga'] as num).toDouble();
      }
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog terlebih dahulu
              Navigator.pop(context); // Kembali ke halaman sebelumnya
            },
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
        title: const Text('Payment'),
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : PaymentBody(
              username: _username,
              seller: _seller,
              selectedItems: selectedItems,
              balance: (_userData?['saldo'] ?? 0).toDouble(),

              totalPrice: totalPrice,
              addOrderController: _addOrderController,
              onAddMenuClicked: () =>
                  _showAddMenuOverlay(), // Sample to add item
              onProcessPayment: _processPayment,
            ),
    );
  }

  void _showAddMenuOverlay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Food'),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: foodItems.map((foodItem) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 2.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade300), 
                    borderRadius: BorderRadius.circular(
                        3.0), 
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            foodItem['nama_makanan'],
                            overflow:
                                TextOverflow.visible, // Prevent text overflow
                            maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Stock info
                        Text(
                          'Stock: ${foodItem['stok']}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Rp ${foodItem['harga']}',
                      style: TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      _addMenuItem(foodItem);
                      Navigator.pop(context);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
