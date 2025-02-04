import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/seller/seller_controller.dart';
import '../../../widgets/seller/history_list_card.dart'; // Pastikan Anda memiliki widget ini

class FoodOrderHistory extends StatelessWidget {
  const FoodOrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        centerTitle: true,
      ),
      body: FoodOrderHistoryList(),
    );
  }
}

class FoodOrderHistoryList extends StatefulWidget {
  @override
  _FoodOrderHistoryState createState() => _FoodOrderHistoryState();
}

class _FoodOrderHistoryState extends State<FoodOrderHistoryList> {
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
    // Jika _userData belum terisi, tampilkan loading spinner
    if (_userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('order')
          .where('seller', isEqualTo: _userData?['nama'])
          .where('status', whereIn: ['done', 'declined']) // Query untuk status 'done' dan 'accepted'
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

            return HistoryOrderCard(
              buyer: data['buyer'] ?? 'Unknown',
              date: orderDate,
              totalAmount: totalAmount,
              status: data['status'] ?? 'Unknown',
              onDetails: () => _orderDetailsOverlay(data),
            );
          },
        );
      },
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
