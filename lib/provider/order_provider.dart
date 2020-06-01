import 'dart:convert';

import 'cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  final String _authToken;
  final String _userId;
  List<OrderItem> _orders = [];

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  // --- adding cart items to the order list ------
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://shop-venue-9304b.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'title': cp.title,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          OrderItem(
              id: DateTime.now().toString(),
              amount: total,
              products: cartProducts,
              dateTime: DateTime.now()));
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  // fetching order from the firebase
  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-venue-9304b.firebaseio.com/orders/$_userId.json?auth=$_authToken";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> _loadedOrders = [];
      if (extractedData == null) {
        return;
      }
      print(extractedData.toString());
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(OrderItem(
            id: orderId,
            amount: double.parse(orderData['amount'].toString()),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                      id: item['id'],
                      price: double.parse(item['price'].toString()),
                      quantity: item['quantity'],
                      title: item['title'],
                    ))
                .toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
