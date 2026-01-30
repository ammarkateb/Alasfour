import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'screens/loading_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/final_screen.dart';
import 'screens/qr_scanner_screen.dart';
import 'screens/winners_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/products_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  debugPaintSizeEnabled = false;
  debugPaintBaselinesEnabled = false;
  debugPaintLayerBordersEnabled = false;
  debugPaintPointersEnabled = false;
  runApp(const AlasfourApp());
}

class AlasfourApp extends StatelessWidget {
  const AlasfourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alasfour Family Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFDF1217), // Use the peak gradient color
        fontFamily: 'Tajawal',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDF1217),
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      home: const LoadingScreen(),
      routes: {
        '/intro': (context) => const IntroScreen(),
        '/home': (context) => const AlasfourFinalScreen(),
        '/final': (context) => const AlasfourFinalScreen(),
        '/qr-scanner': (context) => QRScannerScreen(),
        '/winners': (context) => const WinnersScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/products': (context) => const ProductsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/product-details': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}
