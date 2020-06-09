import 'package:firebase_database/firebase_database.dart';

class fcmTokens {
  String tokenID;
  //String title;
  String customerID;


  fcmTokens({this.tokenID, this.customerID});



  fcmTokens.fromMap(Map<dynamic , dynamic> value , String key)
      : this.tokenID = key,
        this.customerID = value["customerID"];

  fcmTokens.fromSnapshot(DataSnapshot snap)
      : this.tokenID = snap.key,
        this.customerID = snap.value["customerID"];



}
