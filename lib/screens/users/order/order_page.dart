import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/screens/users/order/order_history_page.dart';
import '../../../controllers/users/user_controller.dart'; // Pastikan Anda punya controller ini untuk mengambil data seller
import '../../../widgets/user/order_card.dart'; // Mengimpor FoodOrderCard dari folder widget


class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OrderHistoryScreen()), // Navigasi ke halaman baru
              );
            },
          ),
        ],
      ),
      body: OrderScreenList(),
    );
  }
}

class OrderScreenList extends StatefulWidget {
  @override
  _OrderScreenListState createState() => _OrderScreenListState();
}

class _OrderScreenListState extends State<OrderScreenList> {
  String? _username;
  Map<String, dynamic>? _userData;
  final UserController _userController = UserController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        // Ganti dengan method yang sesuai untuk mengambil data seller
        final data = await _userController.getUserData(_username!);
        setState(() {
          _userData = data; // Ganti dengan field yang benar jika perlu
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
    // Jika _sellerName belum terisi, tampilkan loading spinner
    if (_userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('order')
          .where('status', whereIn: ['accepted', 'pending'])
          .where('buyer', isEqualTo: _userData?['username'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No accepted orders available.'));
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final data = order.data() as Map<String, dynamic>;
            final orderDate = data['date'] as String;
            final totalAmount = (data['total']?? 0).toDouble();

            final pickedUpTime = data['pickupTime'] as String;
            final status = data['status'] as String;

            return OrderCard(
              orderId: order.id,
              seller: data['seller'] ?? 'Unknown',
              date: orderDate,
              totalAmount: totalAmount,
              pickedUpTime: pickedUpTime,
              status: status,
              onDetails: () => _orderDetailsOverlay(data),
            );
          },
        );
      },
    );
  }

  Future<void> _orderDetailsOverlay(Map<String, dynamic> orderData) async {
    final items = orderData['items'] as List<dynamic>;
    final seller = orderData['seller'];
    String sellerAddress = 'Unknown';
    String sellerContact = 'Unknown';

    try {
      final sellerQuerySnapshot = await FirebaseFirestore.instance
          .collection('seller')
          .where('nama', isEqualTo: seller)
          .get();

      if (sellerQuerySnapshot.docs.isNotEmpty) {
        final sellerData = sellerQuerySnapshot.docs.first.data();
        sellerAddress = sellerData['alamat'] ?? 'Address not available';
        sellerContact = sellerData['kontak'] ?? 'Contact not available';
      } else {
        sellerAddress = 'Seller address not found';
      }
    } catch (e) {
      sellerAddress = 'Error retrieving address: $e';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Details'),
        content: Column(
          children: [
            Text('Address: $sellerAddress'),
            Text('Contact: $sellerContact'),
            const SizedBox(height: 8),
            Container(
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
          ],
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
