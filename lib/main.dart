import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'controllers/cart_controller.dart';
import 'controllers/menu_controller.dart' as menu;
import 'controllers/order_controller.dart';
import 'constants/app_constants.dart';

void main() {
  runApp(const CafeCultureApp());
}

class CafeCultureApp extends StatelessWidget {
  const CafeCultureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartController()),
        ChangeNotifierProvider(create: (_) => menu.MenuController()),
        ChangeNotifierProvider(create: (_) => OrderController()),
      ],
      child: MaterialApp(
        title: 'Cafe Culture',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppConstants.primaryColor,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const SplashScreen(),
      ),
    );
  }
}