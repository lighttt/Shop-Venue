import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/auth_provider.dart';
import 'package:shopvenue/provider/cart_provider.dart';
import 'package:shopvenue/provider/order_provider.dart';
import 'package:shopvenue/provider/products_provider.dart';
import 'package:shopvenue/screens/auth_screen.dart';
import 'package:shopvenue/screens/cart_screen.dart';
import 'package:shopvenue/screens/edit_product_screen.dart';
import 'package:shopvenue/screens/order_screen.dart';
import 'package:shopvenue/screens/product_details_screen.dart';
import 'package:shopvenue/screens/product_overview_screen.dart';
import 'package:shopvenue/screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Products()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop Venue',
        theme: ThemeData(
            primaryColor: Colors.blueGrey,
            accentColor: Colors.red,
            fontFamily: "Lato"),
        home: AuthScreen(),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
