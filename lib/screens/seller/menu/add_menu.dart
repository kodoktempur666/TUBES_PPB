import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/add_menu_controller.dart';
import '../../../widgets/seller/add_menu_form.dart';
import '../../../controllers/seller_controller.dart';

class AddMenu extends StatefulWidget {
  const AddMenu({super.key});

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final AddMenuController _menuController = AddMenuController();
  String? _username;
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
      _username = prefs.getString('username');

      if (_username != null) {
        final data = await _sellerController.getUserData(_username!);
        setState(() {
          _userData = data;
          _seller = _userData?['nama'];
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


  Future<void> _handleAddMenu({
    required String namaMakanan,
    required int harga,
    required String deskripsi,
    required String kategori,
    required int stok,
  }) async {
    if (_seller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seller not loaded')),
      );
      return;
    }

    try {
      await _menuController.addMenu(
        namaMakanan: namaMakanan,
        harga: harga,
        deskripsi: deskripsi,
        kategori: kategori,
        stok: stok,
        seller: _seller!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding menu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddMenuForm(
          onSubmit: _handleAddMenu,
        ),
      ),
    );
  }
}
