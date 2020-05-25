import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  //total items in the cart
  int get itemCount {
    return _items == null ? 0 : _items.length;
  }

  //total amount in the cart
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // remove particular item from cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // remove single item from the cart
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(productId, (existingCartItem) {
        return CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1);
      });
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // adding items to the cart
  void addItem(String productId, double price, String title) {
    const url = "https://shop-venue-9304b.firebaseio.com/cart.json";
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCarItem) => CartItem(
                id: existingCarItem.id,
                title: existingCarItem.title,
                price: existingCarItem.price,
                quantity: existingCarItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  // --- to clear all items from the cart -----
  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
