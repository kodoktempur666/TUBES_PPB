import 'package:flutter/material.dart';
import '../menu/add_menu.dart';
import '../order/food_order.dart';
import '../profile/seller_profile.dart';
import '../../../widgets/seller/bottom_navbar.dart';
import '../../../widgets/seller/order_list_card.dart';
import '../../../controllers/seller/seller_controller.dart';
import '../../../style/color_style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerMenuPage extends StatefulWidget {
  @override
  _SellerMenuPageState createState() => _SellerMenuPageState();
}

class _SellerMenuPageState extends State<SellerMenuPage> {
  int _selectedIndex = 0;

  List<Widget> _pages = <Widget>[
    SellerMenuScreen(),
    FoodOrder(),
    AddMenu(),
    SellerProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class SellerMenuScreen extends StatefulWidget {
  @override
  _SellerMenuScreenState createState() => _SellerMenuScreenState();
}

class _SellerMenuScreenState extends State<SellerMenuScreen> {
  String? _username;
  Map<String, dynamic>? _userData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SellerController _sellerController = SellerController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username');

      if (_username != null) {
        final data = await _sellerController.getUserData(_username!);
        setState(() {
          _userData = data;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to load user data: $e');
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
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // Header Container
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: ColorStyle.primary,
                  child: Column(
                    children: [
                      // Welcome Text and Balance
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hi, ${_userData?['nama'] ?? 'Guest'}\nWelcome to Back!',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Balance',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(
                                'Rp ${_userData?['saldo'] ?? 0}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Order List',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 24)),
                ),
                Container(
                  height: 400.0, // Atur tinggi sesuai kebutuhan Anda
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('order')
                        .where('seller', isEqualTo: _userData?['nama'])
                        .where('status', isEqualTo: 'pending')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No orders available.'));
                      }

                      final orders = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final data = order.data() as Map<String, dynamic>;

                          return OrderCard(
                            status: data['status'] ?? 'Unknown',
                            totalAmount: 'Rp ${data['total'] ?? '0'}',
                            username: data['buyer'] ?? 'Unknown',
                            date: data['date'] ?? 'Unknown',
                            onAccept: () =>
                                _updateOrderStatus(order.id, 'accepted', data),
                            onDecline: () =>
                                _updateOrderStatus(order.id, 'declined', data),
                            onDetails: () => _orderDetailsOverlay(data),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> _updateOrderStatus(
      String orderId, String status, Map<String, dynamic> orderData) async {
    try {
      final buyer = orderData['buyer'];
      final seller = orderData['seller'];
      final total = orderData['total'];
      final items = orderData['items'] as List<dynamic>;

      if (status == 'accepted') {
        // Tambahkan saldo seller
        final sellerQuery = await _firestore
            .collection('seller')
            .where('nama', isEqualTo: seller)
            .get();

        if (sellerQuery.docs.isNotEmpty) {
          final sellerDocId = sellerQuery.docs.first.id;
          await _firestore.collection('seller').doc(sellerDocId).update({
            'saldo': FieldValue.increment(total),
          });
        } else {
          throw Exception('Seller not found for name: $seller');
        }
      } else if (status == 'declined') {
        // Tambahkan saldo buyer
        final userQuery = await _firestore
            .collection('users')
            .where('username', isEqualTo: buyer)
            .get();

        if (userQuery.docs.isNotEmpty) {
          final userDocId = userQuery.docs.first.id;
          await _firestore.collection('users').doc(userDocId).update({
            'saldo': FieldValue.increment(total),
          });
        } else {
          throw Exception('Buyer not found for username: $buyer');
        }

        // Tambahkan kembali stok makanan
        for (var item in items) {
          final foodName = item['nama_makanan']; // Nama makanan
          final quantity = item['quantity']; // Jumlah makanan

          // Ambil dokumen makanan berdasarkan nama makanan
          final foodQuery = await _firestore
              .collection('foods')
              .where('nama_makanan', isEqualTo: foodName)
              .get();

          // Periksa jika dokumen makanan ditemukan
          if (foodQuery.docs.isNotEmpty) {
            final foodDocId = foodQuery.docs.first.id;
            // Perbarui stok makanan
            await _firestore.collection('foods').doc(foodDocId).update({
              'stok': FieldValue.increment(quantity),
            });
          } else {
            throw Exception('Food not found for name: $foodName');
          }
        }
      }

      // Perbarui status pesanan
      await _firestore.collection('order').doc(orderId).update({
        'status': status,
      });

      _showSuccessDialog('Order has been $status.');
    } catch (e) {
      _showErrorDialog('Failed to update order status: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
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

  void _orderDetailsOverlay(Map<String, dynamic> orderData) {
    final items = orderData['items'] as List<dynamic>;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: Container(
          height: 250,
          width: double.maxFinite,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item['nama_makanan']),
                subtitle: Text('Quantity: ${item['quantity']}'),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
