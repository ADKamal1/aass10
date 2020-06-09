import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/LocationMaps/CustomerLocation.dart';
import 'package:basket/LocationMaps/theMap.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/cities.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/orders.dart';
import 'package:basket/_model/regions.dart';
import 'package:basket/_model/usingCoupons.dart';
import 'package:basket/screens/purchase/confirmRecipt.dart';
import 'package:basket/screens/purchase/widgets/customListTile.dart';
import 'package:basket/utils/size_config.dart';
import 'package:basket/_model/times.dart';
import 'package:intl/intl.dart';
class PurchaseLocation extends StatefulWidget {

  usingCoupons couponUsed;
  bool hasCoupon = false;
  customers customer;
  cities customerCities;

  List<Product_Offer> productsForOffer = <Product_Offer>[];
  PurchaseLocation({this.hasCoupon ,
    this.couponUsed,this.customer , this.customerCities , this.productsForOffer,
    });
  @override
  _PurchaseLocationState createState() => _PurchaseLocationState();
}

class _PurchaseLocationState extends State<PurchaseLocation> {

  /// two color for two button
  Color todoyButton = Colors.white;
  Color tomorrowButton = Colors.white;

  ///- to get lat and log of customer order Location
  CustomerLocation ob = new CustomerLocation();

  //double currentCustomerLatitude = widget.customer.customerLat;
  //double currentCustomerLongitude ;

  ////-- get old location (location in customer in server when arrive that screen )
  ////- when customer click to continue check for Lat and Log for customer
  //// - if customer still in old location donot update and choose new location from map
  ////-  check for old location or current location (if it 0.0 that mean frist time for customer to make order)
  //// - so should customer choose location from map that frist time
  ////-   if (current location == value ) that same value donot change i disply message for customer that
  //// order will arrive on old Location OR
  /// if you want arrive order to new Location go to Map and determine New Location

  FirebaseDatabase _database = FirebaseDatabase.instance;

  Times selectedtimes;
  List<Times> citiesLists = <Times>[];
  List<String> times;

  ///- this varaible for knowing Orders Numbers has arrived For Max Order Or not
  bool ordersNumberMax = false;

  ///- to display List for Regions that customer choose one Region to order
  getAllDeliveryTimesList() async {
    await _database
        .reference()
        .child("time")
        .child(widget.customerCities.cityID)
        .child("times")
    //.child("cities")
        .once()
        .then((DataSnapshot snapshot) {
      print("dfadsfa " + snapshot.value.toString());
      List<dynamic> productList = snapshot.value;
      productList.forEach((value) async{
        Times nextCity = Times.fromMap(value);
        citiesLists.add(nextCity);
      });
        }).then((v){
      if(mounted)
        setState(() {});
    });
  }


  @override
  void initState() {
    super.initState();
    getAllDeliveryTimesList();

    print("\n\n\n\ +++  ");
    double currentCustomerLatitude = widget.customer.customerLat;
    double currentCustomerLongitude = widget.customer.customerLong;

  }




  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
            appBar: AppBar(
              title: Text(translations.text("PuchaseLocationPage.title")),
              backgroundColor: Color(0XFF21d493),
              centerTitle: true,
            ),
            body: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: SizeConfig.getResponsiveWidth(5.0),
                      right: SizeConfig.getResponsiveWidth(5.0)),
                  height: SizeConfig.getResponsiveHeight(220.0),
                  child: Card(
                      elevation: 5.0,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.getResponsiveHeight(8.0)),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: SizeConfig.getResponsiveWidth(30.0),
                                    height:
                                        SizeConfig.getResponsiveHeight(30.0),
                                    child: Card(
                                        color: Color.fromRGBO(229, 249, 238, 1),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                        elevation: 0,
                                        child: Image.asset(
                                            'assets/images/icons/location.png'))),
                                Text(
                                  translations.text("PuchaseLocationPage.HomeText"),
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.getResponsiveHeight(20.0)),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      top: 20.0, left: 20.0, right: 20.0),
                                  child: Text(
                                   translations.text("PuchaseLocationPage.NameText"),
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.getResponsiveHeight(
                                                16.0),
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                      top:
                                          SizeConfig.getResponsiveHeight(20.0)),
                                  child:(widget.customer ==null)?Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ): Text(
                                     widget.customer.name,
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.getResponsiveHeight(
                                                12.0)),
                                  ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  margin:
                                      EdgeInsets.only(left: 20.0, right: 20.0),
                                  child: Text(
                                       (translations.currentLanguage =='ar')?"المنطقه :":"region : ",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.getResponsiveHeight(
                                                16.0),
                                        fontWeight: FontWeight.bold),
                                  )),
                              (widget.customerCities == null)? Container(
                                color: Colors.white,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )  : Container(
                                  child: Text(
                                    (translations.currentLanguage =='ar')?
                                    widget.customerCities.arabicTitle:
                                    widget.customerCities.title,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.getResponsiveHeight(12.0)),
                              ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                  margin:
                                      EdgeInsets.only(left:SizeConfig.getResponsiveWidth(20.0), right: SizeConfig.getResponsiveWidth(20)),
                                  child: Text(
                                    translations.text("PuchaseLocationPage.PhoneText"),
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.getResponsiveHeight(
                                                15.0),
                                        fontWeight: FontWeight.bold),
                                  )),
                              (widget.customer.phone == null)?Container(
                                  child: Text(
                                    "no telephone",
                                    style: TextStyle(
                                        fontSize:
                                        SizeConfig.getResponsiveHeight(12.0)),
                                  )): Container(
                                  child: Text(
                                    widget.customer.phone,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.getResponsiveHeight(12.0)),
                              ))
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              Container(
                                  margin:
                                  EdgeInsets.only(left:SizeConfig.getResponsiveWidth(20.0), right: SizeConfig.getResponsiveWidth(20)),
                                  child: Text(
                                    translations.text("PuchaseLocationPage.DelivaryDateText"),
                                    style: TextStyle(
                                        fontSize: SizeConfig.getResponsiveHeight(10.0),
                                        fontWeight: FontWeight.bold),
                                  )),
                              Row(
                                  children: <Widget>[
                                    Container(
                                      height: 60,
                                      width: 100,
                                      child: Card(
                                        color: todoyButton,
                                        elevation: 3,
                                        child: FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              todoyButton = Colors.green;
                                              tomorrowButton = Colors.white;
                                            });
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(translations.currentLanguage=='en'?"Today\n":"\nالـيـومـ",
                                              style: TextStyle(fontSize: 15),),
                                              Text(
                                                today.day.toString() + "-" +
                                                    today.month.toString() + "-" +
                                                    today.year.toString(),
                                              ),
                                            ],
                                          ),
                              ), ),
                                    ),
                                    Container(
                                      height: 60,
                                      width: 100,
                                      child: Card(
                                        color: tomorrowButton,
                                        elevation: 3,
                                        child: FlatButton(
                                          onPressed: (){
                                            setState(() {
                                              todoyButton = Colors.white;
                                              tomorrowButton = Colors.green;
                                            });
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Text(translations.currentLanguage=='en'?"Tomorrow\n":"\nغــداَ",
                                                style: TextStyle(fontSize: 15),),
                                              Text(
                                                tomorrow.day.toString() + "-" +
                                                    tomorrow.month.toString() + "-" +
                                                    tomorrow.year.toString(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: <Widget>[
                              Container(
                                  margin:
                                  EdgeInsets.only(left:SizeConfig.getResponsiveWidth(20.0), right: SizeConfig.getResponsiveWidth(20)),
                                  child: Text(
                                    translations.text("PuchaseLocationPage.DelivaryTimeText"),
                                    style: TextStyle(
                                        fontSize: SizeConfig.getResponsiveHeight(10.0),
                                        fontWeight: FontWeight.bold),
                                  )),
                              DropdownButton<Times>(
                                hint: (translations.currentLanguage == 'ar')?
                                Text("قم بإخنيار الوقت المراد التوصيل به"):
                                Text("Choose Your Delivary Time"),
                                value: selectedtimes,
                                onChanged: (Times Value) {
                                  setState(() {
                                    selectedtimes = Value;
                                  });
                                },
                                items: citiesLists.map((Times time) {
                                  return  DropdownMenuItem<Times>(
                                    value: time,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.access_time),
                                        SizedBox(width: 10,),
                                        Text(
                                          time.from+" :: "+time.to ,
                                          style:  TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),

                        ],
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: SizeConfig.getResponsiveWidth(70.0), right: SizeConfig.getResponsiveWidth(40.0), top: SizeConfig.getResponsiveHeight(30)),
                  child: new FlatButton(
                    padding: EdgeInsets.all(7.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    color: Color.fromRGBO(229, 249, 239, 1),
                    child: Row(
                      children: <Widget>[
                        Image.asset("assets/images/maps_location.png", width: 40,color: Colors.black,),
                        new Text(
                          translations.text("PuchaseLocationPage.mapButton"),
                          style: TextStyle(
                              fontSize: SizeConfig.getResponsiveHeight(10),
                              color: Color.fromRGBO(33, 213, 147, 1)),
                        ),
                      ],
                    ),
                    onPressed: () async{
                      ob = await Navigator.push(context,new MaterialPageRoute(
                          builder: (context)=>theMapClass()));

                      widget.customer.customerLat=ob.customerLocationLatitude;
                      widget.customer.customerLong=ob.customerLocationLongitude;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: SizeConfig.getResponsiveWidth(120.0),
                      left: SizeConfig.getResponsiveWidth(120.0),
                      top: SizeConfig.getResponsiveHeight(80.0)),
                  child: new FlatButton(
                    padding: EdgeInsets.all(7.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    color: Color(0XFF21d493),
                    child: new Text(
                      translations.text("PuchaseLocationPage.ContinueButton"),
                      style: TextStyle(
                          fontSize: SizeConfig.getResponsiveHeight(15),
                          color: Colors.white),
                    ),
                    onPressed: () {
                      // for sure that customer choose Delivary Date   and (Delivary Time)
                      if(todoyButton==Colors.white&&tomorrowButton==Colors.white)
                        {
                          IconData ico = Icons.today;
                          _showCupertinoDialog(context,ico,translations.text("PuchaseLocationPage.DelivaryDateChoose"));
                        }
                      else if (selectedtimes==null)
                        {
                          IconData ico = Icons.timer;
                          _showCupertinoDialog(context,ico,translations.text("PuchaseLocationPage.DelivaryTimeChoose"));
                        }
                      else if (selectedtimes!=null)
                        {
                          TimeOfDay _startTime = TimeOfDay(hour:int.parse(
                              selectedtimes.from.split(":")[0]),minute: int.parse(selectedtimes.from.split(":")[1]));

                          TimeOfDay _finishTime = TimeOfDay(hour:int.parse(
                              selectedtimes.to.split(":")[0]),minute: int.parse(selectedtimes.to.split(":")[1]));

                          TimeOfDay now = TimeOfDay.now();
                          int nowInMinute = now.hour *60  + now.minute;
                          int _startTimeInMinute = _startTime.hour *60 + _startTime.minute;
                          int _finishTimeInMinute = _finishTime.hour *60 + _finishTime.minute;

                          //print("\n\n"+_startTime.toString().substring(10,15));
                          //DateTime startDelivaryTime = DateTime.parse(_startTime);
                          //DateTime finishtDelivaryTime = DateTime.parse(selectedtimes.to);
                          //DateTime now = DateTime.now();
                          ///- to prevent any order after 1 hour from starting perioad
                          if(nowInMinute>_startTimeInMinute+60)
                            {
                              IconData ico = Icons.timer;
                              _showCupertinoDialog(context,ico,translations.text("PuchaseLocationPage.DelivaryTimeChooseFalse"));
                            }
                          else
                            {
                              if(todoyButton==Colors.green)
                                {
                                  print("333333333777:::");
                                  _ordersNumbersLessMax(today,selectedtimes);
                                }
                              else
                                _ordersNumbersLessMax(tomorrow,selectedtimes);

                              ///- i sure that Order Numbers  < Max go to determine Location
                              if(!ordersNumberMax)
                              {
                              if(widget.customer.customerLat==1.1&&widget.customer.customerLong==1.1)
                              {
                                _showDialogFrist(context);
                              }else if (ob.customerLocationLatitude==0.0&&ob.customerLocationLongitude==0.0)
                              {
                                _showDialogSecond(context,today,tomorrow);
                              }else{
                                print("\n\n\nss:"+selectedtimes.from);
                                print("\n\n"+selectedtimes.to);
                                print("\n\n"+today.toString());
                                //// update new customer informations mu adding New Location
                                updateCustomerLocation(ob.customerLocationLatitude,ob.customerLocationLongitude);
                                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                                    builder: (context) =>
                                        ConfirmRecipt(
                                            deliveryDate: todoyButton==Colors.green?today:tomorrow,
                                            deliveryDateForm: selectedtimes.from,
                                            deliveryDateTo: selectedtimes.to,
                                            hasCoupon: widget.hasCoupon ,
                                            couponUsed: widget.couponUsed,
                                            customer:widget.customer  ,
                                            customerCities:widget.customerCities,
                                            productsForOffer:widget.productsForOffer)));

                              }

                              }
                              else {
                                IconData ico = Icons.warning;
                                _showCupertinoDialog ( context, ico, translations.text("PuchaseLocationPage.DelivaryTimeChooseMaxFalse"));
                              }

                            }


                        }


                    },
                  ),
                )
              ],
            ));
      });
    });
  }

  updateCustomerLocation(double newLat, double newLong) async {
    //// update new customer informations mu adding New Location
    await _database.reference ( ).child ( "customers" )
        .child ( widget.customer.customerID )
        .set ( {
      "email":widget.customer.email,
      "gender":"male",
      "isBlocked":false ,
      "name":widget.customer.name,
      "latitude":newLat,
      "longitude":newLong,
      "phone":widget.customer.phone,
      "token":widget.customer.token

    });
  }

  ///--- this alert Dialog for customer if (he Must choose his location for First Time)
  void _showDialogFrist(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: Icon(Icons.map,color: Colors.black,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(translations.text("PuchaseLocationPage.dailogForFirstTime"),
                    style: TextStyle(fontSize: 18.0),
                  ), /////////localiz
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          child:
                          translations.currentLanguage=='ar'?
                          Text("حــــسـنـــــاً"):
                          Text( 'OK',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.white))),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  ///--- this alert Dialog for customer if (he choose his location befor)
  void _showDialogSecond (BuildContext context,DateTime todoy ,DateTime tomorrow) {
    showDialog(
        context: context,
        builder: (ctx) =>
           AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: Icon(Icons.map,color: Colors.black,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    translations.text("PuchaseLocationPage.dailogForSecondTime"),
                    style: TextStyle(fontSize: 18.0),
                  ), /////////localiz
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      onPressed: () async {
                        /// move order by Old Location
                        print('\n\nhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh\n');
                        print(widget.hasCoupon);
                        //Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                        Navigator.of(context).pushReplacement( new MaterialPageRoute(
                            builder: (context) =>
                                new ConfirmRecipt(
                                    deliveryDate: todoyButton==Colors.green?todoy:tomorrow,
                                    deliveryDateForm: selectedtimes.from,
                                    deliveryDateTo: selectedtimes.to,
                                    hasCoupon: widget.hasCoupon ,
                                    couponUsed: widget.couponUsed,
                                    customer:widget.customer  ,
                                    customerCities:widget.customerCities,
                                    productsForOffer:widget.productsForOffer)));

                      },
                      child: Container(
                          child: Text(
                              translations.text(
                                  "ProductDetailstPage.AlertDialogConfirmButton"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.white))),
                    ),
                    RaisedButton(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                          child: Text(
                              translations.text(
                                  "ProductDetailstPage.AlertDialogCancelButton"),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.white))),
                    )
                  ],
                )
              ],
            ),
          ),
        );
  }

  void _showCupertinoDialog(BuildContext context,IconData icons,String choose) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: Icon(icons,color: Colors.green,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text("$choose",
                    style: TextStyle(fontSize: 18.0),
                  ), /////////localiz
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          child:
                          translations.currentLanguage=='ar'?
                          Text("حــــسـنـــــاً"):
                          Text( 'OK',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0,
                                  color: Colors.white))),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }



    void _ordersNumbersLessMax(DateTime delivDate , Times selectTime) async {
      TimeOfDay _startTime = TimeOfDay ( hour: int.parse (
          selectTime.from.split ( ":" )[0] ),
          minute: int.parse ( selectTime.from.split ( ":" )[1] ) );

      int thatOrderTimeChoosen = _startTime.hour * 60 + _startTime.minute;

      int OrderNumbersTotal = 0;
      //print ( "\n\n  333  s: " + delivDate.toString ( ) );

      String delivaryDate = delivDate.year.toString()+delivDate.month.toString()
          +delivDate.day.toString();

         await _database
            .reference ( )
            .child ( "orders" )
            //.orderByChild ( "deliveryDate" )
            //.equalTo (delivaryDate)
            .once ( )
            .then ( (DataSnapshot snapshot) async {
          Map<dynamic, dynamic> ordersMap = snapshot.value;
          await ordersMap.forEach ( (key, value) async {
            orders nextOrder = orders.fromMap ( value, key );

            String orderDelivarytime = nextOrder.deliveryDate.year.toString()+nextOrder.deliveryDate.month.toString()
                +nextOrder.deliveryDate.day.toString();

            ////- convert time of orders to minutes
            int orderDelivarytimeMinute = nextOrder.deliveryDateForm.hour * 60 +
                nextOrder.deliveryDateForm.minute;

//            print("\n\n : "+orderDelivarytimeMinute.toString()+"::"+thatOrderTimeChoosen.toString());
            ////- to knowin numbers of orders that has made in same time
            if (delivaryDate == orderDelivarytime) {
              /// - how numbers of orders in that time
              if(thatOrderTimeChoosen==orderDelivarytimeMinute)
                {
                  print("\n\n44444:::");
                  OrderNumbersTotal++;
                }
            }
          } );
        } ).whenComplete ( () {
          if (mounted) setState ( () {} );
        } );

        if (OrderNumbersTotal == int.parse ( selectTime.max )) {
          print("\n\n5555:::");
          ordersNumberMax = true;
        }
        else
          ordersNumberMax = false;


  }

}


_dismissDialog(BuildContext context) {
  Navigator.pop(context);
}
