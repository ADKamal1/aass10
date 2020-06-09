import 'package:flutter/material.dart';
import 'package:basket/database/database_helper.dart';

class FavouriteServices with ChangeNotifier {
  var db = new DatabaseHelper();

  Future<int> getFavouriteStatus(String productId, String category) async {
    bool found = await db.isProductFoundInFavouriteTable(productId);
    if (found == true) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> triggerFavourite(String productId, String category) async {
    int status = await getFavouriteStatus(productId, category);
    if (status == 0) {
      db.addProductToFavourite(productId, category);
      return 1;
    } else {
      db.deleteUsers(productId);
      return 0;
    }
  }
}
