import 'package:flutter/material.dart';
import 'package:shopvenue/screens/order_screen.dart';
import 'package:shopvenue/screens/product_overview_screen.dart';
import 'package:shopvenue/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('Manish Tuladhar'),
            accountEmail: Text('manish.eclipse@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://avatars0.githubusercontent.com/u/24526752?s=400&u=cd0f100e560323ac8656bcb996523203a80311f9&v=4'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, UserProductScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
