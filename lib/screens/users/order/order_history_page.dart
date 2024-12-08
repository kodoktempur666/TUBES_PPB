import 'package:flutter/material.dart';
import '../../../widgets/user/history_card.dart'; 

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OverlayEntry? _overlayEntry;

  // Data pesanan
  final List<Map<String, dynamic>> orders = [
    {
      'id_pesanan': 'ORDER101',
      'date': 'Oct 24, 2024',
      'pickupTime': '9.40 pm',
      'status': 'COMPLETED',
      'statusColor': Colors.green,
      'items': [
        {'name': 'Classic Style Noodle', 'quantity': 1},
        {'name': 'Classic Style Fried Rice', 'quantity': 1},
      ],
      'seller': 'Warung mie bang ucok',
      'total': 'Rp 60.000',
    },
    {
      'id_pesanan': 'ORDER102',
      'date': 'Oct 26, 2024',
      'pickupTime': '10.00 pm',
      'status': 'DECLINED',
      'statusColor': Colors.redAccent,
      'items': [
        {'name': 'Sate Padang', 'quantity': 1},
        {'name': 'Sate Madura', 'quantity': 1},
      ],
      'seller': 'Warung Sate',
      'total': 'Rp 30.000',
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            _removeOverlay();
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
        title: Text(
          'Order History',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...orders.map((order) => HistoryCard(
                  order: order,
                  onToggleDetails: () {
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
