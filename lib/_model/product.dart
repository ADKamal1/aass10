import 'package:firebase_database/firebase_database.dart';

class Product {
  String categoryId;
  String title;
  String arabicTitle;
  int quantity = 0;
  String photo;
  double price;
  double afterDiscountPrice;
  String stockQuantity;
  String description;
  String arabicDescription;
  String productId;
  double priceAfterOffer = 0.0;
  String arabicQuantityType;
  String englishQuantityType;
  //var bodyBytes;


  Product(
      {this.categoryId,
      this.title,
      this.arabicTitle,
      this.photo,
      this.price,
      this.afterDiscountPrice,
      this.stockQuantity,
      this.description,
      this.arabicDescription,
      this.arabicQuantityType,
      this.englishQuantityType});

  Map toJson() => {
        'title': title,
        'arabicTitle': arabicTitle,
        'photo': photo,
        'price': price,
        'afterDiscountPrice': afterDiscountPrice,
        'stockQuantity': quantity,
        'description': description,
        'arabicDescription': arabicDescription,
        'productId': productId,
        'categoryId': categoryId
      };

  Product.fromSnapshot(DataSnapshot snap)
      : this.title = snap.value["title"],
        this.arabicTitle = snap.value["arabicTitle"],
        this.photo = snap.value["photo"],
        this.price = double.parse(snap.value["price"])+0.0,
        this.afterDiscountPrice = snap.value["afterDiscountPrice"],
        this.stockQuantity = snap.value["quantity"],
        this.description = snap.value["description"],
        this.arabicDescription = snap.value["arabicDescription"],
        this.productId = snap.key,
        this.englishQuantityType = snap.value["englishQuantityType"],
        this.arabicQuantityType = snap.value["arabicQuantityType"],
        this.categoryId = snap.value["CategoriesId"];

  Product.fromMap(Map<dynamic , dynamic> value , String key)
      : this.productId = key,
        this.title = value["title"],
        this.arabicTitle = value["arabicTitle"],
        this.photo = value["photo"],
        this.price = double.parse(value["price"])+0.0,
        this.afterDiscountPrice = value["afterDiscountPrice"],
        this.stockQuantity = value["quantity"],
        this.description = value["description"],
        this.arabicDescription = value["arabicDescription"],
        this.englishQuantityType = value["englishQuantityType"],
        this.arabicQuantityType = value["arabicQuantityType"],
        this.categoryId = value["CategoriesId"];

  Map toMap() {
    return {
      "title": title,
      "arabicTitle": arabicTitle,
      "photo": photo,
      "price": price,
      "afterDiscountPrice": afterDiscountPrice,
      "stockQuantity": quantity,
      "description": description,
      "arabicDescription": arabicDescription,
      "productId": productId,
      "categoryId": categoryId
    };
  }
}
