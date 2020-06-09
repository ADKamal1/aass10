import 'package:firebase_database/firebase_database.dart';

class orders {
  String orderID;
  String customerID;
  String cityID;
  String deliveryManID;
  //DateTime date;
  double totalPrice;
  bool usedCreditCard;
  int state;
  String token;

  DateTime deliveryDate;
  DateTime deliveryDateForm;
  DateTime deliveryDateTo;

  orders({this.orderID,this.customerID, this.cityID, this.deliveryManID,this.token,
      this.totalPrice, this.usedCreditCard, this.state,this.deliveryDate, this.deliveryDateForm,this.deliveryDateTo});

  Map toJson() => {
        'customerID': customerID,
        'cityID': cityID,
        'deliveryManID': deliveryManID,
        //'date': date,
        'totalPrice': totalPrice,
        'usedCreditCard': usedCreditCard,
        'state': state,
      };

  orders.fromSnapshot(DataSnapshot snap){
     this.orderID = snap.key;
    this.customerID = snap.value["customerID"];
     this.token = snap.value["token"];

    this.cityID = snap.value["cityID"];
    this.deliveryManID = snap.value["deliveryManID"];
    //this.date = DateTime.parse(snap.value["date"]);
    this.totalPrice = snap.value["totalPrice"]+0.0;
    this.usedCreditCard = snap.value["usedCreditCard"];
    this.deliveryDate = DateTime.parse(snap.value["deliveryDate"]);
    this.deliveryDateForm = DateTime.parse(snap.value["deliveryDateForm"]);
    this.deliveryDateTo = DateTime.parse(snap.value["deliveryDateTo"]);

     String orderState = snap.value["state"];
     if(orderState == "pending")
       this.state = 0;
     else if(orderState == "delivering"){
       this.state = 1;
     }else if(orderState == "charged"){
       this.state = 2;
     }else{
       this.state = 3;
     }
  }

  orders.fromMap(Map<dynamic , dynamic> value , String key)
  {  this.orderID = key;
        this.customerID = value["customerID"];
        this.cityID = value["cityID"];
        this.deliveryManID = value["deliveryManID"];
        this.token = value["token"];

  //this.date = value["date"];
        this.totalPrice = value["totalPrice"];
        this.usedCreditCard = value["usedCreditCard"];
        this.deliveryDate = DateTime.parse(value["deliveryDate"]);
        this.deliveryDateForm = DateTime.parse(value["deliveryDateForm"]);
        this.deliveryDateTo = DateTime.parse(value["deliveryDateTo"]);


        String orderState = value["state"];
        if(orderState == "pending")
            this.state = 0;
        else if(orderState == "delivering"){
            this.state = 1;
        }else if(orderState == "charged"){
          this.state = 2;
        }else if(orderState == "inProgress"){
          this.state = 3;
        }else{
          this.state = 4;
        }
  }

//  Map toMap() {
//    return {
//      "orderID": orderID,
//      "customerID": customerID,
//      "cityID": cityID,
//      "deliveryManID": deliveryManID,
//      //"date": date,
//      "totalPrice": totalPrice,
//      "usedCreditCard": usedCreditCard,
//      "state": state,
//    };
//  }
}
