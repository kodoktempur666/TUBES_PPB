import 'package:flutter/material.dart';
import 'explore_page.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String _mood = 'Sad';
  String _foodPreference = 'Sweet';
  String _drinkPreference = 'Sweet';
  bool pressAttention1 = false;
  bool pressAttention2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Your Preferences'),
        backgroundColor: Color(0xFF8B4572),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Set Your Preferences, Satisfy Your Taste Curated Just for You',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Mood Selection
            Text('How\'s your mood today?', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _moodButton('Sad'),
                _moodButton('Bored'),
                _moodButton('Very Happy'),
              ],
            ),
            SizedBox(height: 16),
            // Food & Drink Preferences
            Text('Food or Beverage', style: TextStyle(fontSize: 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _preferenceButtonfood('Food', Colors.grey),
                _preferenceButtondrink('Drink', Colors.grey),
              ],
            ),
            SizedBox(height: 16),
            // Food Preference
            Text('Which do you prefer?', style: TextStyle(fontSize: 16)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _preferenceOption('Sweet'),
                SizedBox(height: 16.0), // Menambahkan jarak antar elemen
                _preferenceOption('Spicy'),
                SizedBox(height: 16.0), // Menambahkan jarak antar elemen
                _preferenceOption('Salty'),
              ],
            ),

            SizedBox(height: 16),
            // Find Me Food Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExplorePage()),
                  );
                },
                child: Text(
                  'Find Me Food',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDA3EA2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _moodButton(String mood) {
    return Row(
      children: [
        Radio<String>(
          value: mood,
          groupValue: _mood,
          onChanged: (value) {
            setState(() {
              _mood = value!;
            });
          },
        ),
        Text(mood),
      ],
    );
  }

  // Tambahkan variabel untuk melacak status tekan

  Widget _preferenceButtonfood(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          pressAttention1 = !pressAttention1; // Toggle warna tombol
        });
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: pressAttention1
            ? Colors.red
            : color, // Mengubah warna tombol berdasarkan status tekan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: Colors.red, // Warna ketika tombol tidak aktif
        overlayColor: color.withAlpha(50), // Memberikan efek saat ditekan
      ),
    );
  }

  Widget _preferenceButtondrink(String label, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          pressAttention2 = !pressAttention2; // Toggle warna tombol
        });
      },
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: pressAttention2
            ? Colors.blue
            : color, // Mengubah warna tombol berdasarkan status tekan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: Colors.blue, // Warna ketika tombol tidak aktif
        overlayColor: color.withAlpha(50), // Memberikan efek saat ditekan
      ),
    );
  }

  Widget _preferenceOption(String option) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _foodPreference = option;
        });
      },
      child: Text(option),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
