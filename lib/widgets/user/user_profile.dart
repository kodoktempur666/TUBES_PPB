import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileWidget extends StatelessWidget {
  final String? nama;
  final String? username;
  final String? kontak;
  final String? password;
  final double? saldo;

  // Constructor to receive profile data
  ProfileWidget({
    required this.nama,
    required this.username,
    required this.kontak,
    required this.password,
    required this.saldo,
  });

  String formatCurrency(double value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileField('Nama', nama),
          _buildProfileField('Username', username),
          _buildProfileField('Kontak', kontak),
          _buildProfileField('Password', password),
          _buildProfileField('Saldo', formatCurrency(saldo!)),
        ],
      ),
    );
  }

  // Widget to display label and profile data with custom style
  Widget _buildProfileField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '$label: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(width: 10), // Add spacing between label and value
              Expanded(
                child: Text(
                  value ?? 'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  overflow:
                      TextOverflow.ellipsis, // Handle long text gracefully
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
