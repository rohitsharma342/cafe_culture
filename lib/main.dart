import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafe_culture/utils/app_theme.dart';
import 'package:cafe_culture/screens/splash_screen.dart';
import 'package:cafe_culture/controllers/cart_controller.dart';
import 'package:cafe_culture/controllers/menu_controller.dart' as menu;
import 'package:cafe_culture/controllers/order_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(CartController());
    Get.put(menu.MenuController());
    Get.put(OrderController());
    
    return GetMaterialApp(
      title: 'Cafe Culture',
      theme: AppTheme.lightTheme,
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}