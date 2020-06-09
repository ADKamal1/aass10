import 'package:firebase_database/firebase_database.dart';

class notifications {
  String notificationID;
  //String title;
  String message;


  notifications({this.notificationID, this.message});



  notifications.fromMap(Map<dynamic , dynamic> value , String key)
      : this.notificationID = key,
        this.message = value["message"];

  notifications.fromSnapshot(DataSnapshot snap)
      : this.notificationID = snap.key,
        this.message = snap.value["message"];



}
