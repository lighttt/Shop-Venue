import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopvenue/models/product.dart';
import 'package:shopvenue/provider/auth_provider.dart';
import 'package:shopvenue/provider/cart_provider.dart';
import 'package:shopvenue/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedProduct = Provider.of<Product>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                arguments: selectedProduct.id);
          },
          child: Hero(
            tag: 'product${selectedProduct.id}',
            child: FadeInImage(
              placeholder: AssetImage("assets/images/placeholder.png"),
              image: NetworkImage(
                selectedProduct.imageURL,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            selectedProduct.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, prod, _) {
              return IconButton(
                icon: Icon(
                  selectedProduct.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                onPressed: () {
                  selectedProduct.toggleIsFavourite(auth.userId, auth.token);
                },
                color: Theme.of(context).accentColor,
              );
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(selectedProduct.id, selectedProduct.price,
                  selectedProduct.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: Text("Added item to the cart!"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  textColor: Colors.black,
                  onPressed: () {
                    cart.removeSingleItem(selectedProduct.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
