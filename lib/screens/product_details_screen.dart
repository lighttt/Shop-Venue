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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                selectedProduct.title,
              ),
              background: Hero(
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
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$ ${selectedProduct.price}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 28),
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
              ),
              SizedBox(
                height: 700,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
