import 'dart:ffi';

import 'package:basket/_model/times.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:basket/_model/delivarytime.dart';
import 'package:basket/_model/times.dart';

class Time {
  String timeID ;
  List<Times> times ;


  Time(this.timeID, this.times);


//  Times.fromSnapshot(DataSnapshot snap)
//      : this.timeID = snap.key,
//        this.from = snap.value["from"],
//        this.index1 = snap.value["index"],
//        this.max = snap.value["max"],
//        this.to = snap.value["to"];

  Time.fromMap(Map<dynamic, dynamic> value):
    this.timeID = value["key"] ,
    this.times = value["times"];


}
