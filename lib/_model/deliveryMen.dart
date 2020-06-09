import 'package:firebase_database/firebase_database.dart';

class deliveryMen {
  String name;
  String arabicName;
  String phone;
  String email;
  String cityID;
  String deliveryMenID;
  // for notification
  String token;

  deliveryMen(
      this.name, this.arabicName, this.phone, this.email, this.cityID,this.token);

  Map toJson() => {
        "name": name,
        "arabicName": arabicName,
        "phone": phone,
        "email": email,
        "cityID": cityID,
        "token": token
      };

  deliveryMen.fromSnapshot(DataSnapshot snap)
      : this.deliveryMenID = snap.key,
        this.name = snap.value["name"],
        this.arabicName = snap.value["arabicName"],
        this.phone = snap.value["phone"],
        this.email = snap.value["email"],
        this.cityID = snap.value["cityID"],
        this.token = snap.value["token"];

  deliveryMen.fromMap(Map<dynamic, dynamic> value, String key)
      : this.deliveryMenID = key,
        this.name = value["name"],
        this.arabicName = value["arabicName"],
        this.phone = value["phone"],
        this.email = value["email"],
        this.cityID = value["cityID"],
        this.token = value["token"];

  Map toMap() {
    return {
      "name": name,
      "arabicName": arabicName,
      "phone": phone,
      "email": email,
      "cityID": cityID,
      "token": token
    };
  }
}
