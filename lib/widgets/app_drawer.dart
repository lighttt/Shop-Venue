import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopvenue/helper/custom_route.dart';
import 'package:shopvenue/provider/auth_provider.dart';
import 'package:shopvenue/screens/auth_screen.dart';
import 'package:shopvenue/screens/order_screen.dart';
import 'package:shopvenue/screens/product_overview_screen.dart';
import 'package:shopvenue/screens/user_product_screen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isInit = true;
  String email = "";
  String userType = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      getUserData();
    }
    isInit = false;
  }

  void getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    print(extractedData);
    setState(() {
      email = extractedData["email"];
      userType = extractedData["userType"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Manish Tuladhar'),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars0.githubusercontent.com/u/24526752?s=400&u=cd0f100e560323ac8656bcb996523203a80311f9&v=4'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              //Navigator.pushReplacementNamed(context, OrderScreen.routeName);
              Navigator.of(context).pushReplacement(
                  CustomRoute(builder: (ctx) => OrderScreen()));
            },
          ),
          Divider(),
          userType == "client"
              ? Container()
              : Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Manage Products'),
                      onTap: () {
//              Navigator.pushReplacementNamed(
//                  context, UserProductScreen.routeName);
                        Navigator.of(context).pushReplacement(
                            CustomRoute(builder: (ctx) => UserProductScreen()));
                      },
                    ),
                    Divider(),
                  ],
                ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              Navigator.of(context).pop();
              await Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
