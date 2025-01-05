import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart'; // Import GetX
import 'screens/users/main_users/user_main.dart';
import 'screens/seller/main_seller/seller_main.dart'; // Halaman menu untuk seller
import 'screens/login/login_page.dart'; // Halaman login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inisialisasi Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Change to GetMaterialApp
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: 'Poppins', // Set the default font family to Poppins
      ),
      routes: {
        '/': (context) => LoginPage(),
        '/userMainMenu': (context) => MainMenuPage(),
        '/sellerMainMenu': (context) => SellerMenuPage(),
      },
    );
  }
}
