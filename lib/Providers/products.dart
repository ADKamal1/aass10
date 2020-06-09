import 'package:basket/_model/product.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  FirebaseDatabase _database = FirebaseDatabase.instance;

  List<Product> _items = [];
  List<Product> _categoryitems = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get categoryitems {
    return [..._categoryitems];
  }

  Future<void> fetchAndSetProducts() async {
    // get the products

    _items.clear();
    await _database
        .reference()
        .child("products")
        .orderByChild("title")
        .limitToFirst(50)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> productsMap = snapshot.value;
      productsMap.forEach((key, value) async {
        Product p = Product.fromMap(value, key);
        _items.add(p);
      });
    });
  }

  Future<void> getListProductOfSpecificCategory(String categoryId) async {
// get the products
    // _items.clear();
    _categoryitems.clear();
    await _database
        .reference()
        .child("products")
        .orderByChild("CategoriesId")
        .equalTo(categoryId)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> productsMap = snapshot.value;
      //_categoryitems.clear();
      productsMap.forEach((key, value) async {
        Product p = Product.fromMap(value, key);
        _categoryitems.add(p);
      });
    });
  }
}
