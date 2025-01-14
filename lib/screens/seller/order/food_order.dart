import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/seller/seller_controller.dart'; // Pastikan Anda punya controller ini untuk mengambil data seller
import '../../../widgets/seller/food_order_card.dart'; // Mengimpor FoodOrderCard dari folder widget
import '../../seller/order/food_order_history.dart';

class FoodOrder extends StatelessWidget {
  const FoodOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Order'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FoodOrderHistory()), // Navigasi ke halaman baru
              );
            },
          ),
        ],
      ),
      body: FoodOrderList(),
    );
  }
}

class FoodOrderList extends StatefulWidget {
  @override
  _FoodOrderListState createState() => _FoodOrderListState();
}

class _FoodOrderListState extends State<FoodOrderList> {
  String? _username;
  Map<String, dynamic>? _userData;
  final SellerController _sellerController = SellerController();
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
        final data = await _sellerController.getUserData(_username!);
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
          .where('status', isEqualTo: 'accepted')
          .where('seller', isEqualTo: _userData?['nama'])
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
            final totalAmount = (data['total'] as num).toDouble();

            return FoodOrderCard(
              orderId: order.id,
              buyer: data['buyer'] ?? 'Unknown',
              date: orderDate,
              totalAmount: totalAmount, // Pastikan dikirim dalam bentuk double
              onPickedUp: () => _markAsPickedUp(order.id),
              onDetails: () => _orderDetailsOverlay(data),
            );
          },
        );
      },
    );
  }

  Future<void> _markAsPickedUp(String orderId) async {
    try {
      await _firestore.collection('order').doc(orderId).update({
        'status': 'done',
      });
      print('Order marked as picked up');
    } catch (e) {
      print('Failed to update order status: $e');
    }
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
