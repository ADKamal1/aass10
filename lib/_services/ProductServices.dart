import 'package:firebase_database/firebase_database.dart';
import 'package:basket/_model/product.dart';

class ProductService {
  FirebaseDatabase _database = FirebaseDatabase.instance;

  List<Product> productList = <Product>[];

  String productNode = "products";
  bool load = false;

  List<Product> getAllProductsFromDB() {
    load = false;
    _database.reference().child("product").once().then((DataSnapshot snapshot) {
      for (var val in snapshot.value.values) {
        productList.add(Product.fromMap(val,"adsf"));
       }
    }).then((v){
      load = true;
      return productList;
    });

  }

  List<Product> getCategoryProducts(String categoryID) {
    List<Product> productsForCategory = <Product>[];
    List<Product> productForCategoryLists = <Product>[];
    for (int i = 0; i < productsForCategory.length; i++) {
      Product currentProduct = productsForCategory.elementAt(i);
      if (currentProduct.categoryId == categoryID) {
        productForCategoryLists.add(productsForCategory.elementAt(i));
      }
    }

    return productForCategoryLists;
  }
}
