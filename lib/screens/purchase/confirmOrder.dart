import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/cities.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/orders.dart';
import 'package:basket/_model/regions.dart';
import 'package:basket/screens/home_page/widgets/appbar.dart';
import 'package:basket/screens/purchase/widgets/OrderQrCode.dart';
import 'package:basket/screens/purchase/widgets/confirmOrder_card.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/locationCard.dart';
import 'package:firebase_database/firebase_database.dart';

class ConfirmOrder extends StatefulWidget {
 String orderID;
 String CityID;
 double totalPrice;
  ConfirmOrder({this.orderID , this.CityID , this.totalPrice});
  @override
  _ConfirmOrderState createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String customerId;
  orders customerOrder;
  customers customer;
  cities customerCity;
bool loadCustomerRegion = false;

   ////-- to get all informations about Region that order will delivered to it
  getCustomerCity() async{
   await _database
     .reference().child("cities").child(widget.CityID)
         .once().then((DataSnapshot snapshot){
          customerCity = cities.fromSnapshot(snapshot);
           loadCustomerRegion = true;
     }).then((_){
         if(mounted){
            setState(() {
            });
         }
     });
  }
   ////-- to get all informations about Customer that order will delivered to it
  getCustomerDetails() async{
     await _database
         .reference()
         .child("customers")
         .child(customerId)
         .once().then((DataSnapshot snapshot){
            customer = customers.fromSnapshot(snapshot);
     }).then((_){
         if(mounted){
             setState(() {
             });
         }
     });
  }

   ////-- to get all informations about  that order
  getTheOrderDetails() async {
    await _database
        .reference()
        .child("orders")
        .child(widget.orderID)
        .once()
        .then((DataSnapshot snapshot) {
      customerOrder = orders.fromSnapshot(snapshot);
    }).then((v) {
      if (mounted) {
        setState(() {
          state = customerOrder.state;
        });
      }
    });
  }

  initState() {
     FirebaseAuth.instance.currentUser().then((user) {
      customerId = user.uid;
    }).whenComplete(() async {
      await getTheOrderDetails();
      await getCustomerCity();
      await getCustomerDetails();
      if (mounted) setState(() {});
    });

    if(customer != null){
       if(customer.phone == null){
           customer.phone = "no phone provided";
       }
    }
  }

  int state = 0;
  @override
  Widget build(BuildContext context) {

    getTheOrderDetails();
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          appBar: myCartAppbar(_scaffoldKey, Text("Continue")),
          body: ListView(
            children: <Widget>[
              loadCustomerRegion == true?
              ConfirmCard(
                  customerRegion: customerCity,
                  totalPrice: widget.totalPrice):Container(),
              Card(
                elevation: 0,
                child: Container(
                  color: Color.fromRGBO(229, 249, 238, 1),
                  padding: EdgeInsets.all(SizeConfig.getResponsiveHeight(10)),
                  margin: EdgeInsets.all(SizeConfig.getResponsiveHeight(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          color: Color.fromRGBO(229, 249, 238, 1),
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(translations.text("ConfirmOrderPage.followYourOrder"),
                            style: TextStyle(
                                fontSize: SizeConfig.getResponsiveHeight(15.0),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                color: Color(0XFF21d493),
                margin: EdgeInsets.only(
                    bottom: SizeConfig.getResponsiveHeight(10),
                    right: SizeConfig.getResponsiveWidth(90.0),
                    left: SizeConfig.getResponsiveWidth(90.0),
                    top: SizeConfig.getResponsiveHeight(2)),
                child: new FlatButton(
                  padding: EdgeInsets.all(7.0),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  child: new Text(translations.text("ConfirmOrderPage.DelivaryQrCodeButton"),
                    style: TextStyle(
                        fontSize: SizeConfig.getResponsiveHeight(15),
                        color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                        OrderQrCode(qrText: widget.orderID+customerId,)));

                    //OrderQrCode(qrText: widget.orderID+customerId,);
                  },
                ),
              ),

              Center(
                  child: Container(
                height: 190,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 5.0,
                          offset: Offset(1.0, -10))
                    ]),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: SizeConfig.getResponsiveHeight(30),
                            width: SizeConfig.getResponsiveWidth(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green[50],
                            ),
                            child: Image.asset(
                              "assets/images/oder_statu.png",
                              scale: 2.2,
                            )),
                        SizedBox(width: 10),
                        Text(
                          "Client Order",
                          style: TextStyle(fontSize: SizeConfig.getResponsiveWidth(20)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Container(
                          height: 3,
                          color: Colors.green[100],
                          margin: EdgeInsets.only(left: 60, right: 60),
                        ),
                      ),
                      // if state ==1
                      (state == 1)
                          ? Padding(
                              padding: EdgeInsets.only(top: 25),
                              child: Container(
                                height: 3,
                                color: Colors.green[800],
                                margin: EdgeInsets.only(left: 60, right: 200),
                              ),
                            )
                          // if state == 2
                          : (state == 2)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 25),
                                  child: Container(
                                    height: 3,
                                    color: Colors.green[800],
                                    margin:
                                        EdgeInsets.only(left: 60, right: 120),
                                  ),
                                )
                              :
//
// if state == 3
                              (state == 3)
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 25),
                                      child: Container(
                                        height: 3,
                                        color: Colors.green[900],
                                        margin: EdgeInsets.only(
                                            left: 60, right: 60),
                                      ),
                                    )
                                  : Container(),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.getResponsiveWidth(35), right: SizeConfig.getResponsiveWidth(35)),
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Column(children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(height: SizeConfig.getResponsiveHeight(45),width: SizeConfig.getResponsiveWidth(30),decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green[50],),child: Image.asset("assets/images/charged.png",scale: 3.0)),
                              Container(height: SizeConfig.getResponsiveHeight(45),width:  SizeConfig.getResponsiveWidth(30),decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green[50],),child: Image.asset("assets/images/delivered.png",scale: 3.0)),
                              Container(height: SizeConfig.getResponsiveHeight(45),width:  SizeConfig.getResponsiveWidth(30),decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green[50],),child: Image.asset("assets/images/inprogress.png",scale: 3.0,)),
                              Container(height: SizeConfig.getResponsiveHeight(45),width:  SizeConfig.getResponsiveWidth(30),decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green[50],),child: Image.asset("assets/images/your_order_done.png",scale: 3.0)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: SizeConfig.getResponsiveWidth(50),
                                child: Text(translations.text("ConfirmOrderPage.orderStatufrist"),
                                  softWrap: true,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: SizeConfig.getResponsiveWidth(11)),
                                ),
                              ),
                              Container(
                                width: SizeConfig.getResponsiveWidth(50),
                                child: Text(translations.text("ConfirmOrderPage.orderStatusecond"),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize:  SizeConfig.getResponsiveWidth(11)),
                                ),
                              ),
                              Container(
                                width: SizeConfig.getResponsiveWidth(50),
                                child: Text(translations.text("ConfirmOrderPage.orderStatuthird"),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize:  SizeConfig.getResponsiveWidth(11)),
                                ),
                              ),
                              Container(
                                width: SizeConfig.getResponsiveWidth(50),
                                child: Text(translations.text("ConfirmOrderPage.orderStatuDone"),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize:  SizeConfig.getResponsiveWidth(11)),
                                ),
                              ),
                            ],
                          ),
                        ]),
                      )
                    ],
                  ),
                ]),
              ))
            ],
          ),
        );
      });
    });
  }
}
