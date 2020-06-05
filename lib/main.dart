import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/helper/custom_route.dart';
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
import 'package:shopvenue/screens/splash_screen.dart';
import 'package:shopvenue/screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (BuildContext context, Auth auth, Products previousProducts) {
            return Products(auth.token, auth.userId,
                previousProducts == null ? [] : previousProducts.items);
          },
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext context, Auth auth, Orders previousOrders) {
            return Orders(auth.token, auth.userId,
                previousOrders == null ? [] : previousOrders.orders);
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop Venue',
            theme: ThemeData(
                primaryColor: Colors.blueGrey,
                accentColor: Colors.red,
                fontFamily: "Lato",
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTranisitionBuilder(),
                  TargetPlatform.iOS: CustomPageTranisitionBuilder(),
                })),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
