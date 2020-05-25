import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopvenue/exception/http_exception.dart';
import 'package:shopvenue/models/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//      id: "first",
//      title: "Watch",
//      price: 2000.0,
//      description: "The best watch that fits both classy and modern look.",
//      imageURL:
//          "https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1562694533-4fee55cc-7d92-4518-bed7-8a39ad51d9c2.jpg",
//      isFavourite: false,
//    ),
//    Product(
//      id: "second",
//      title: "Shirt",
//      price: 1000.0,
//      description: "Red shirt for retro look.",
//      imageURL:
//          "https://assets.abfrlcdn.com/img/app/product/2/268602-1069000-large.jpg",
//      isFavourite: false,
//    ),
//    Product(
//      id: "third",
//      title: "Laptop",
//      price: 200000.0,
//      description:
//          "The best gaming laptop that runs the high fps games for you seamlessly.",
//      imageURL:
//          "https://i.gadgets360cdn.com/large/mi_gaming_laptop_2019_image_1565003115644.jpg",
//      isFavourite: false,
//    ),
//    Product(
//      id: "fourth",
//      title: "Shoes",
//      price: 3000.0,
//      description: "The causal street wear to match with all your outfits.",
//      imageURL:
//          "https://cdn.sportsshoes.com/product/N/NIK16356/NIK16356_1000_1.jpg",
//      isFavourite: false,
//    )
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favourites {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  //this function adds new product
  Future<void> addProduct(Product product) async {
    const url = "https://shop-venue-9304b.firebaseio.com/products.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
            'isFavourite': product.isFavourite,
          }));
      // the future gives a response after posting to the database
      print(json.decode(response.body)['name']);
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          price: product.price,
          description: product.description,
          imageURL: product.imageURL);
      _items.add(newProduct);
      notifyListeners();
    }
    // if we get an error during post we catch the error
    // and execute accordingly
    catch (error) {
      print(error);
      throw (error);
    }
  }

  //this function fetches the products from firebase
  Future<void> fetchAndSetProducts() async {
    const url = "https://shop-venue-9304b.firebaseio.com/products.json";
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData["description"],
          price: double.parse(prodData['price'].toString()),
          isFavourite: prodData['isFavourite'],
          imageURL: prodData['imageURL'],
        ));
      });
      _items = loadedProducts;
      print(_items[0].price);
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw (error);
    }
  }

  //this function updates the current product
  Future<void> updateProduct(String id, Product upProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      if (prodIndex >= 0) {
        final url = "https://shop-venue-9304b.firebaseio.com/products/$id.json";
        await http.patch(url,
            body: json.encode({
              'title': upProduct.title,
              'description': upProduct.description,
              'imageURL': upProduct.imageURL,
              'price': upProduct.price,
            }));
        _items[prodIndex] = upProduct;
        notifyListeners();
      }
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

  // this function deletes the current product
  Future<void> deleteProduct(String id) async {
    final url = "https://shop-venue-9304b.firebaseio/products/$id.json";
    final existingProductIndex = items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException("Could not delete product");
      } else {
        existingProduct = null;
      }
    } catch (error) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
  }
}
