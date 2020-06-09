import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:basket/_model/orders.dart';
import 'package:basket/utils/size_config.dart';
import 'Localization/translation/global_translation.dart';
import '_model/customerOrderDetails.dart';
import '_model/customers.dart';
import 'orderCard.dart';

class MyOrder extends StatefulWidget {

  //customers authenticatedCustomer;
//  bool isAuthenticated = false;
//  MyOrder({this.isAuthenticated });

  @override
  _MyOrder createState() => _MyOrder();
}

class _MyOrder extends State<MyOrder> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  customers authenticatedCustomer;
  bool isAuthenticated = false;


  //customers authenticatedCustomer;
  CustomerOrderDetails customerDetails;
  List<CustomerOrderDetails> customerDetailsList = <CustomerOrderDetails>[];


  @override
  void initState() {
    super.initState();
    getOrdersForSpecificCustomer();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0XFF21d493),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text(translations.currentLanguage=='en'?"My Orders":"طـلـبـاتــــي",
                  style: TextStyle(
                    fontSize: SizeConfig.getResponsiveWidth(25.0),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            child: ListView(
              children: <Widget>[
                (customerDetailsList.length == 0)
                        ? Container(
                  margin: EdgeInsets.all(SizeConfig.getResponsiveWidth(10)),
                  child: Center(
                    child: Text("No Previous Order",
                      style: TextStyle(
                          fontSize: SizeConfig.getResponsiveWidth(25.0),
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                  :Container(
                            margin: EdgeInsets.all(
                                SizeConfig.getResponsiveWidth(10)),
                            child: Center(
                              child: Text("All My Orders",
                                //translations.text("AllOrderPage.title"),
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.getResponsiveWidth(25.0),
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: customerDetailsList.length,
                        itemBuilder: (context, ind) {
                          return Ordercard(
                            authenticatedCustomer: authenticatedCustomer,
                              customerDetails: customerDetailsList.elementAt(ind));
                        }),
              ],
            ),
          ),
        );
      });
    });
  }

  void getOrdersForSpecificCustomer() async {

    FirebaseAuth.instance.currentUser().then((user) async{
      if(user != null) {
        String userId = user.uid;
        isAuthenticated = true;
        await FirebaseDatabase.instance.reference().child("customers").
        child(userId).once().then((DataSnapshot snapshot){
          authenticatedCustomer = customers.fromSnapshot(snapshot);
        });
      }else{
        isAuthenticated = false;
      }
    }).then((d){
      if(mounted)
        setState(() {

        });
    }).whenComplete((){
     _database
        .reference()
        .child("orders")
        .orderByChild("customerID")
        .equalTo(authenticatedCustomer.customerID) ////.equalTo(delivaryId)
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> ordersMap = snapshot.value;
      ordersMap.forEach((key, value) async {
        CustomerOrderDetails next = new CustomerOrderDetails();
        orders order = orders.fromMap(value, key);
        next.customerOrder = order;
        customerDetailsList.add(next);
      });
    }).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  },
    );}
}
