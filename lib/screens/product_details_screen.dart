import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/provider/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product_details_screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final selectedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              child: Container(
                height: 300,
                width: double.infinity,
                child: Image.network(
                  selectedProduct.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              tag: 'product$id',
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$ ${selectedProduct.price}',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 28),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
