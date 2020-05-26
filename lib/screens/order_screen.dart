import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/order_provider.dart' show Orders;
import 'package:shopvenue/widgets/app_drawer.dart';
import 'package:shopvenue/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text("Error Occurred! Something went wrong. Try Again!"),
              );
            } else {
              return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                        itemCount: orderData.orders.length,
                      ));
            }
          }
        },
      ),
    );
  }
}
