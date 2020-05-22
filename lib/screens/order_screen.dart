import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/order_provider.dart' show Orders;
import 'package:shopvenue/widgets/app_drawer.dart';
import 'package:shopvenue/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(orderData[i]),
        itemCount: orderData.length,
      ),
    );
  }
}
