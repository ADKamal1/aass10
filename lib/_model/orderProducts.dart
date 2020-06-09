import 'package:firebase_database/firebase_database.dart';

class orderProducts {
  String orderProductID;
  String orderID;
  String productID;
  double quantity;
  double price;

  orderProducts(this.orderID, this.productID, this.quantity, this.price);

  Map toJson() => {
        'orderProductID': orderProductID,
        'orderID': orderID,
        'productID': productID,
        'quantity': quantity,
        'price': price
      };

  orderProducts.fromSnapshot(DataSnapshot snap)
      : this.orderProductID = snap.key,
        this.orderID = snap.value["orderID"],
        this.productID = snap.value["productID"],
        this.quantity = snap.value["quantity"],
        this.price = snap.value["price"];

  Map toMap() {
    return {
      "orderProductID": orderProductID,
      "orderID": orderID,
      "productID": productID,
      "quantity": quantity,
      "price": price
    };
  }
}
