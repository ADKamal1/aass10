import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:basket/_model/delivarytime.dart';

class Times {
  int timeID;
  String from;
  double index1;
  String max;
  String to;


  Times({this.timeID, this.from, this.index1, this.max, this.to});


/////
//  Times.fromMap(Map<dynamic, dynamic> value, int key):
//        this.timeID = key,
//    this.from = value["from"],
//    this.index1 = value["index"],
//    this.max = value["max"],
//    this.to = value["to"];


  Times.fromMap(Map<dynamic, dynamic> value):
    this.from = value["from"],
    this.index1 = value["index"],
    this.max = value["max"],
    this.to = value["to"];

  Map toMap() {
    return {
      "timeID": timeID,
      "from": from,
      "index": index1,
      "max": max,
      "to": to
    };
  }
}
