import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/cities.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/deliveryMen.dart';
import 'package:basket/_model/orders.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/_model/regions.dart';
import 'package:basket/_model/usingCoupons.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/_model/favouritex.dart';
import 'package:basket/screens/home_page/widgets/reviewCard.dart';
import 'package:basket/utils/size_config.dart';
import 'confirmOrder.dart';
import 'widgets/locationCard.dart';
import 'widgets/receiptCard.dart';
import 'package:intl/intl.dart';
class ConfirmRecipt extends StatefulWidget {
  DateTime deliveryDate;
  String deliveryDateForm;
  String deliveryDateTo;
  customers customer;
  cities customerCities;
  bool hasCoupon;
  usingCoupons couponUsed;
  List<Product_Offer> productsForOffer = <Product_Offer>[];
  ConfirmRecipt(
      {this.hasCoupon, this.couponUsed, this.customer, this.customerCities,this.productsForOffer,
      this.deliveryDate,this.deliveryDateForm,this.deliveryDateTo});
  @override
  _ConfirmReciptState createState() => _ConfirmReciptState();
}

class _ConfirmReciptState extends State<ConfirmRecipt> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Product> orderList = <Product>[];
  double totalPriceOfProducts = 0.0;

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(translations.text("PurchasePage.DialogTitle")),
            content: Container(
              width: double.maxFinite,
              child: ListView(
                padding: EdgeInsets.all(8.0),
                children: List.generate(
                  orderList.length,
                  (index) {
                    int productOffer = ifProductHaveOffer(orderList[index].productId);
                    if(productOffer == -1) {

                      return Container(
                          width: 20.0,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: reviewCard(
                                  product: orderList.elementAt(index),
                                  hasOffer: false,
                                  newPrice:0.0
                              )));
                    }else{
                      double newPrice =  orderList[index].price * (widget.productsForOffer.elementAt(productOffer).offer.rate/100);
                      return Container(
                          width: 20.0,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: reviewCard(
                                  product: orderList.elementAt(index),
                                  hasOffer: true,
                                  newPrice:newPrice
                              )));
                    }
                  },
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text(translations.text("PurchasePage.DialogButton")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  double getProductSize(String productID){
    int productOfferIndex = ifProductHaveOffer(productID);
    double price = 0.0;
    if(productOfferIndex != -1){
      Product_Offer product_offer = widget.productsForOffer.elementAt(productOfferIndex);
      price = (product_offer.product.price * (product_offer.offer.rate/100));
    }
    return price;
  }
  // if the product has offer it will return the id else will return -1
  int ifProductHaveOffer(String productID){

    for(int i = 0 ; i < widget.productsForOffer.length ;i++){
      if(widget.productsForOffer.elementAt(i).product.productId == productID){
        return  i;
      }
    }
    return -1;
  }

  void getProductsFromFavourite() async {
    var db = new DatabaseHelper();
    orderList.clear();
    List<Favourite> orders = await db.getAllBasketProductPaths();
    for (int i = 0; i < orders.length; i++) {
      await _database
          .reference()
          .child("products")
          .child(orders.elementAt(i).productPath)
          .once()
          .then((snao) {
        Product nextProduct = Product.fromSnapshot(snao);
         double priceIfOffer = getProductSize(orders.elementAt(i).productPath);
        double nextProductPriceOfQuantity;
        if(priceIfOffer != 0.0){
          nextProductPriceOfQuantity = priceIfOffer * orders.elementAt(i).quantity;
        }else{
          nextProductPriceOfQuantity = nextProduct.price * orders.elementAt(i).quantity;
        }

        totalPriceOfProducts += (nextProductPriceOfQuantity);
        orderList.add(nextProduct);
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getProductsFromFavourite();
  }

  String orderId;
  @override
  Widget build(BuildContext context) {

   double totalPrice= (widget.hasCoupon == true)
        ? widget.couponUsed.afterDiscount
        : totalPriceOfProducts;
    //double deliveryCharge = double.parse(widget.customerCities.fees.toStringAsFixed(2));
    double freeForCashOfDelivery = (totalPrice > 100)?0.0:10;
    double taxes =  double.parse((totalPrice*0.05).toStringAsFixed(2));
    double overAll = double.parse((totalPrice + taxes  + freeForCashOfDelivery).toStringAsFixed(2));
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          appBar: AppBar(
            title: Text(translations.text("ConfirmReciptPage.title")),
            backgroundColor: Color(0XFF21d493),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                ReciptCard(
                    customerCities: widget.customerCities,
                    totalPrice: (widget.hasCoupon == true)
                        ? widget.couponUsed.afterDiscount
                        : totalPriceOfProducts),
                LocationCard(
                  address: (widget.customerCities == null)
                      ? "Cannot Display address"
                      : widget.customerCities.title,
                  telNo: (widget.customer.phone == null)
                      ? "Cannot Display phone"
                      : widget.customer.phone,
                ),
                Container(
                  color: Color.fromRGBO(229, 249, 239, 1),
                  margin: EdgeInsets.only(
                      bottom: SizeConfig.getResponsiveHeight(5.0),
                      right: SizeConfig.getResponsiveWidth(90.0),
                      left: SizeConfig.getResponsiveWidth(90.0),
                      top: SizeConfig.getResponsiveHeight(2)),
                  child: new FlatButton(
                    padding: EdgeInsets.all(7.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    child: new Text(
                      translations.text("ConfirmReciptPage.ReviewYourOrderButton"),
                      style: TextStyle(
                          fontSize: SizeConfig.getResponsiveHeight(15),
                          color: Color.fromRGBO(33, 213, 147, 1)),
                    ),
                    onPressed: () {
                      return _displayDialog(context);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: SizeConfig.getResponsiveWidth(120.0),
                    left: SizeConfig.getResponsiveWidth(120.0),
                    bottom: SizeConfig.getResponsiveWidth(70.0),
                  ),
                  child: new FlatButton(
                    padding: EdgeInsets.all(7.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    color: Color(0XFF21d493),
                    child: new Text(
                      translations.text("ConfirmReciptPage.ConfirmButton"),
                      style: TextStyle(
                          fontSize: SizeConfig.getResponsiveHeight(15),
                          color: Colors.white),
                    ),
                    onPressed: () async{
                      print("\n\n\n"+widget.deliveryDateForm.toString());
                      //DateTime startThatOrderDuration = DateFormat("HH:mm").parse(widget.deliveryDateForm);
                      //DateTime finishThatOrderDuration = DateFormat("HH:mm").parse(widget.deliveryDateTo);
//                      String deliveryDate = widget.deliveryDate.year.toString()+widget.deliveryDate.month.toString()
//                          +widget.deliveryDate.day.toString();
                      //DateTime finishThatOrderDuration = DateTime.parse(widget.deliveryDateTo);

                      ///// - add region id For Customer
                      await _database.reference ( ).child ( "customers" )
                          .child ( widget.customer.customerID )
                          .set ( {
                        "email": widget.customer.email,
                        "gender": "male",
                        "isBlocked": false,
                        "name": widget.customer.name,
                        "latitude": widget.customer.customerLat,
                        "longitude": widget.customer.customerLong,
                        "phone": widget.customer.phone,
                        "regionID": widget.customerCities.cityID,
                        "token":widget.customer.token
                      } );


                      findDeliveryMen(widget.customerCities).then((delveryMan) async{
                        //DateTime now = new DateTime.now();

                         orderId = _database.reference()
                             .child("orders")
                             .push().key;

//                         print("\n\n\n\n\n\n"+widget.customer.customerID);
//                        print("\n\n\n\n\n : "+"1111111111: ");
//                        print(orderId);
                     // push to order
                        _database.reference().child("orders").child(orderId).set({
                          'customerID': widget.customer.customerID,
                          'cityID': widget.customerCities.cityID ,
                          'deliveryManID': delveryMan.deliveryMenID,
                          'totalPrice':overAll,
                          'usedCreditCard': false,
                          'state': 'pending',

                          'deliveryDate': widget.deliveryDate.toString(),
                          'deliveryDateForm':widget.deliveryDateForm,
                          'deliveryDateTo': widget.deliveryDateTo,
                          ///for notification add token of delivery men
                          'token':delveryMan.token
                        });
                         print("\n\n\n\n\n : "+"222222");


//                       orders order = new orders(
//                        customerID: widget.customer.customerID,
//                           cityID: widget.customerCities.cityID,
//                           deliveryManID: delveryMan.deliveryMenID ,
//                           totalPrice: overAll,
//                           usedCreditCard: false ,
//                           state:0,
//                           orderID:orderId,
//                         deliveryDate: widget.deliveryDate,
//                         deliveryDateForm: startThatOrderDuration,
//                         deliveryDateTo: finishThatOrderDuration,
//                         token: delveryMan.token
//
//                       );

                      // push the products in orderProducts
                        for(var product in orderList){
                           _database.reference().child("orderProducts").push()
                               .set({
                                   'orderID': orderId,
                                   'productID': product.productId,
                                   'quantity': translations.currentLanguage=='en'?product.englishQuantityType:product.arabicQuantityType,
                                   'price': product.price
                           });
                        }

                        // push the coupon..
                        if(widget.hasCoupon == true){
                             _database.reference().child("usingCoupons").push().set({
                               'orderID': orderId,
                               'couponID': widget.couponUsed.couponID,
                               'beforeDiscount': widget.couponUsed.beforeDiscount,
                               'afterDiscount': widget.couponUsed.afterDiscount
                             });


                        }
                       double salary =  (widget.hasCoupon == true)
                            ? widget.couponUsed.afterDiscount
                            : totalPriceOfProducts;

                        DateTime timeNow = DateTime.now();
                        String tim = timeNow.hour.toString() + ":" + timeNow.minute.toString()+":"+timeNow.second.toString();
                        var db = new DatabaseHelper();
                        await db.addOrderForCustomer(
                            orderId,
                            widget.customerCities.cityID,
                            salary.toString() , tim).then((df){

                        });


                        /// save in database...
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                            builder: (context) => new ConfirmOrder(
                              orderID: orderId,
                              CityID: widget.customerCities.cityID,
                              totalPrice:  (widget.hasCoupon == true)
                                    ? widget.couponUsed.afterDiscount
                                    : totalPriceOfProducts,

                            )));
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        );
      });
    });
  }






  Future<deliveryMen> findDeliveryMen(cities customerCities) async {
    List<deliveryMen> deliverMenForSpecificRegion = <deliveryMen>[];
    //deliveridAndToken delveryandtoken;

   // List<int> state = <int>[];
//    List<String> deliveryIdForSameRegion = <String>[];
//    String delivaryReturn;
    // get all delivery men that server in that region
    await _database
        .reference()
        .child("deliveryMen")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> productsMap = snapshot.value;
      productsMap.forEach((key, value) {
        deliveryMen nextDeliveryMen = deliveryMen.fromMap(value, key);

        ////- if i have more Delivery Men for Same Region
        if (nextDeliveryMen.cityID == customerCities.cityID) {
          deliverMenForSpecificRegion.add(nextDeliveryMen);
        }
      });
    }).whenComplete(() {
      if (mounted) setState(() {});
    });

//    DatabaseReference rootRef = FirebaseDatabase.instance.reference();
//
//    await _database
//        .reference()
//        .child("orders")
//        .once()
//        .then((DataSnapshot snapshot) {
//      if (snapshot != null){
//        Map<dynamic, dynamic> productsMap = snapshot.value;
//        if(productsMap != null)
//            productsMap.forEach((key, value) {
//              print("value inside = " + value.toString());
//              String regionId = value["regionID"];
//              String deliveryId = value["deliveryManID"];
//              String orderState = value["state"];
//              int deliveryState;
//              if(orderState == "pending")
//                deliveryState = 0;
//              else if(orderState == "delivering"){
//                deliveryState = 1;
//              }else if(orderState == "rejected"){
//                deliveryState = 2;
//              }else{
//                deliveryState = 3;
//              }
//
//
//              if (regionId == customerRegion.regionID) {
//                state.add(deliveryState);
//                deliveryIdForSameRegion.add(deliveryId);
//              }
//            });
//    }else{
//        print("root is not exists in that root");
//      }
//    });

    ///- advanced (if i have more delivery for same region )
    /// how to handle work between them      not reqired now

//   if(deliveryIdForSameRegion != null && deliveryIdForSameRegion.length > 0) {
//     // the prioriy for the delivary man who didn't have any order yet..
//     for (var delivary in deliverMenForSpecificRegion) {
//       // all delivary for specific region
//       bool found = true;
//       String delivaryIdChoosen = delivary.deliveryMenID;
//       for (int i = 0; i < deliveryIdForSameRegion.length; i++) {
//         // all delivaries has order..
//         if (delivaryIdChoosen == deliveryIdForSameRegion.elementAt(i) &&
//             state.elementAt(i) != 3) {
//           found = false;
//         }
//       }
//       if (found == true) {
//         return delivaryIdChoosen;
//       }
//     }
//   }

//    print("\n\n hh");
//    print(deliverMenForSpecificRegion.elementAt(0));
//    print("\n\n ss");
//    print(deliverMenForSpecificRegion.elementAt(0).token);
//   delveryandtoken.delveryMenId = deliverMenForSpecificRegion.elementAt(0).deliveryMenID;
//   delveryandtoken.deliveyMenToken = deliverMenForSpecificRegion.elementAt(0).token;
   return deliverMenForSpecificRegion.elementAt(0);

    //return delveryandtoken;

  }
}

//class deliveridAndToken{
//  String delveryMenId;
//  String deliveyMenToken;
//}