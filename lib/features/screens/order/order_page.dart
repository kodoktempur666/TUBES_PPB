// order_screen.dart
import 'package:flutter/material.dart';
import 'package:tubes/features/screens/order/order_history_page.dart';
import '../../../widgets/order_card.dart';  

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OverlayEntry? _overlayEntry;

  // Data pesanan
  final List<Map<String, dynamic>> orders = [
    {
      'id_pesanan': 'ORDER101',
      'date': 'Oct 24, 2024',
      'pickupTime': '9.40 pm',
      'status': 'ESTIMATED PICK UP',
      'statusColor': Colors.redAccent,
      'items': [
        {'name': 'Classic Style Noodle', 'quantity': 1},
        {'name': 'Classic Style Fried Rice', 'quantity': 1},
      ],
      'seller': 'Warung mie bang ucok',
      'total': 'Rp 60.000',
    },
  ];

  void _showOverlay(BuildContext context, List<Map<String, dynamic>> items) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Order Detail',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 10),
                ...items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        '${item['name']}       x ${item['quantity']}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _removeOverlay();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Order',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: Colors.black),
            onPressed: () {
              _removeOverlay(); // Menutup overlay terlebih dahulu
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryScreen()), // Navigasi ke halaman baru
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...orders.map((order) => OrderCard(
                  order: order,
                  onDetailPressed: () {
                    _overlayEntry == null
                        ? _showOverlay(context, order['items'])
                        : _removeOverlay();
                  },
                )),
          ],
        ),
      ),
    );
  }
}
