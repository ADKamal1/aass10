import 'package:firebase_database/firebase_database.dart';
import 'package:basket/_model/categories.dart';

class CategoryService {
  FirebaseDatabase _database = FirebaseDatabase.instance;

  List<categories> categoryList = <categories>[];

  String categoryNode = "categories";

  List<categories> getAllCategories() {
    _database
        .reference()
        .child(categoryNode)
        .once()
        .then((DataSnapshot snapshot) {
      for (var val in snapshot.value.values) {
        categoryList.add(categories.fromMap(val, "sdaf"));
      }
    });
    return categoryList;
  }
}
