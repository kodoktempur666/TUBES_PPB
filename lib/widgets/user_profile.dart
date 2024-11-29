import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String? nama;
  final String? username;
  final String? kontak;
  final String? password;
  final double? saldo;

  // Konstruktor untuk menerima data profil
  ProfileWidget({
    required this.nama,
    required this.username,
    required this.kontak,
    required this.password,
    required this.saldo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileField('Nama', nama),
        _buildProfileField('Username', username),
        _buildProfileField('Kontak', kontak),
        _buildProfileField('Password', password),
        _buildProfileField('Saldo', 'Rp ${saldo?.toStringAsFixed(0)}'),
      ],
    );
  }

  // Widget untuk menampilkan label dan data profil
  Widget _buildProfileField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'Loading...',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
