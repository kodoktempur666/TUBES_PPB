import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/screens/users/main_users/main_menu.dart';
import 'features/screens/seller/main_seller/seller_menu.dart'; // Halaman menu untuk seller
import 'features/screens/login/login_page.dart'; // Halaman login

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(); // Inisialisasi Firebase
//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan widget diinisialisasi sebelum Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyApJqKQQM4TAdl4bkXhx1N5q-3Ge06-8bY",
      authDomain: "tubes-f55fe.firebaseapp.com",
      projectId: "tubes-f55fe",
      storageBucket: "tubes-f55fe.appspot.com",
      messagingSenderId: "533858284102",
      appId: "1:533858284102:web:fee6a21e70bd38cd8a9047",
      measurementId: "G-9MS7E04SX1",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/userMainMenu': (context) => MainMenuPage(),
        '/sellerMainMenu': (context) => SellerMenuPage(),
      },
    );
  }
}
