import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/cities.dart';
import 'package:basket/_model/coupons.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/delivarytime.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/_model/regions.dart';
import 'package:basket/_model/usingCoupons.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/_model/favouritex.dart';
import 'package:basket/screens/home_page/widgets/reviewCard.dart';
import 'package:basket/screens/purchase/puchaseLocation.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Purchase extends StatefulWidget {
  List<Product_Offer> productsForOffer = <Product_Offer>[];
  Purchase({this.productsForOffer});
  @override
  _PurchaseState createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  customers customer;
  regions customerRegion;
  String customerId;

  Future<void> getCustomerData() async {
    await _database
        .reference()
        .child("customers")
        .child(customerId)
    //TODO the following child is the authentected userId should be changes..
        .once()
        .then((snao) {
      customer = customers.fromSnapshot(snao);
    }).whenComplete((){
      if(mounted){
        setState((){});
      }
    });
  }

  usingCoupons couponUsed = new usingCoupons();
  FirebaseDatabase _database = FirebaseDatabase.instance;
  List orderList = <Product>[];
  List<coupons> couponList = <coupons>[];
  List<String> allRegionsStringList = <String>[];
  double totalPriceIncludesTaxes = 0.0;
  double totalPriceOfProducts = 0.0;
  double couponDecreaseRate = 0.0;
  bool hasCoupon = false;
  double salaryAfterCoupon = 0.0;


  double totalTaxes = 0.0;

  List<String> alltimesStringList = <String>[];



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
                    int productOffer =
                    ifProductHaveOffer(orderList[index].productId);
                    if (productOffer == -1) {
                      return Container(
                          width: 20.0,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: reviewCard(
                                  product: orderList.elementAt(index),
                                  hasOffer: false,
                                  newPrice: 0.0)));
                    } else {
                      double newPrice = orderList[index].price *
                          (widget.productsForOffer
                              .elementAt(productOffer)
                              .offer
                              .rate /
                              100);
                      return Container(
                          width: 20.0,
                          child: FittedBox(
                              fit: BoxFit.contain,
                              child: reviewCard(
                                  product: orderList.elementAt(index),
                                  hasOffer: true,
                                  newPrice: newPrice)));
                    }
                  },
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(translations.text("PurchasePage.DialogButton")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void getProductsFromFavourite() async {
    var db = new DatabaseHelper();
    orderList.clear();
    List<Favourite> orders = await db.getAllBasketProductPaths();
    for (int i = 0; i < orders.length; i++) {
      print("order productPath = " + orders.elementAt(i).productPath);
      await _database
          .reference()
          .child("products")
          .child(orders.elementAt(i).productPath)
          .once()
          .then((snao) {
        Product nextProduct = Product.fromSnapshot(snao);
        double priceIfOffer = getProductSize(orders.elementAt(i).productPath);
        double nextProductPriceOfQuantity;
        if (priceIfOffer != 0.0) {
          nextProductPriceOfQuantity =
              priceIfOffer * orders.elementAt(i).quantity;
        } else {
          nextProductPriceOfQuantity =
              nextProduct.price * orders.elementAt(i).quantity;
        }

        double taxes = (nextProductPriceOfQuantity * 0.05);
        totalTaxes += taxes;
        totalPriceIncludesTaxes += (taxes + nextProductPriceOfQuantity);
        totalPriceOfProducts += (nextProductPriceOfQuantity);
        orderList.add(nextProduct);
      });
    }
    if (mounted) {
      setState(() {});
    }
  }

  double getProductSize(String productID) {
    int productOfferIndex = ifProductHaveOffer(productID);
    double price = 0.0;
    if (productOfferIndex != -1) {
      Product_Offer product_offer =
      widget.productsForOffer.elementAt(productOfferIndex);
      price = (product_offer.product.price * (product_offer.offer.rate / 100));
    }
    return price;
  }

  // if the product has offer it will return the id else will return -1
  int ifProductHaveOffer(String productID) {
    for (int i = 0; i < widget.productsForOffer.length; i++) {
      if (widget.productsForOffer.elementAt(i).product.productId == productID) {
        return i;
      }
    }
    return -1;
  }

  ///- to display List for Regions that customer choose one Region to order
  cities selectedCities;
  List<cities> regionLists = <cities>[];
  List<String> times;

  getAllRegionsList() async {
    await _database
        .reference()
        .child("cities")
        .once()
        .then((DataSnapshot snapshot) {
      print("snapshot region = " + snapshot.value.toString());
      Map<dynamic, dynamic> productsMap = snapshot.value;
      productsMap.forEach((key, value) {
        cities nextCity = cities.fromMap(value, key);
        regionLists.add(nextCity);
      });
    }).then((v){
      if(mounted)
        setState(() {

        });
    });
  }


  @override
  void initState() {

    FirebaseAuth.instance.currentUser().then((user) {
      customerId = user.uid;
    }).whenComplete(() {
      ///- for choose your region
      getAllRegionsList();
      ///- for customer Data
      getCustomerData();
      getProductsFromFavourite();
      _database.reference().child("coupons").once().then((snapshot) {
        Map<dynamic, dynamic> couponMap = snapshot.value;
        DateTime timeNow = DateTime.now();
        couponMap.forEach((key, value) {
          coupons nextCoupon = coupons.fromMap(value, key);
          String fromDatee = nextCoupon.fromDate;
          String toDatee = nextCoupon.toDate;

          if((timeNow.isAfter(DateTime.parse(fromDatee))  && timeNow.isBefore(DateTime.parse(toDatee))) || (timeNow.difference(DateTime.parse(fromDatee)).inDays == 0 || (timeNow.difference(DateTime.parse(toDatee)).inDays == 0)) ){


            couponList.add(nextCoupon);
          }

        });
      }).whenComplete(() {
        setState(() {});
      });
    });
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime orderDelivary = today.add(Duration(days: 3));

    TextEditingController couponController = new TextEditingController();

    final GlobalKey<ScaffoldState> _scaffoldKey =
    new GlobalKey<ScaffoldState>();
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          appBar: AppBar(
            title: Text(translations.text("PurchasePage.title")),
            backgroundColor: Color(0XFF21d493),
            centerTitle: true,
          ),
          body: ListView(children: <Widget>[
            Container(
              child: Card(
                elevation: 3.0,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.getResponsiveHeight(10.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  right: (translations.currentLanguage == 'en')
                                      ? SizeConfig.getResponsiveWidth(80)
                                      : 0,
                                  left: SizeConfig.getResponsiveWidth(80)),
                              child: Text(
                                translations.text("PurchasePage.giftCobon"),
                                style: TextStyle(
                                    fontSize:
                                    SizeConfig.getResponsiveHeight(12.0)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              height: 35.0,
                              width: SizeConfig.getResponsiveWidth(150.0),
                              margin: EdgeInsets.only(
                                  left: SizeConfig.getResponsiveWidth(30.0)),
                              decoration: BoxDecoration(
                                  color: Color(0xffd7f7ea),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(5.0))),
                              child: Container(
                                height: SizeConfig.getResponsiveWidth(30.0),
                                child: new TextField(
                                  controller: couponController,
                                  textAlign:
                                  (translations.currentLanguage == 'en')
                                      ? TextAlign.left
                                      : TextAlign.right,
                                  style: TextStyle(
                                      fontSize:
                                      SizeConfig.getResponsiveHeight(15)),
                                  decoration: new InputDecoration(
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                    fillColor: Color(0xffd7f7ea),
                                    hintText: translations
                                        .text("PurchasePage.CobonHint"),
                                    hintStyle: TextStyle(
                                      fontSize:
                                      SizeConfig.getResponsiveHeight(10),
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                            child: new FlatButton(
                              padding: EdgeInsets.all(7.0),
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                              color: Color(0XFF21d493),
                              child: new Text(
                                translations.text("PurchasePage.CobonButton"),
                                style: TextStyle(
                                    fontSize:
                                    SizeConfig.getResponsiveHeight(12),
                                    color: Colors.white),
                              ),
                              onPressed: () {
                                String enteredCoupon = couponController.text;
                                couponController.text = "";
                                coupons yourGiftCoupon = null;
                                for (var c in couponList) {
                                  if (enteredCoupon == c.cobonCode) {
                                    yourGiftCoupon = c;
                                  }
                                }
                                if (yourGiftCoupon == null) {
                                  hasCoupon = false;
                                } else {
                                  couponDecreaseRate =
                                      calculateCouponDecreaseRate(
                                          totalPriceOfProducts,
                                          yourGiftCoupon.decreaseRate,
                                          yourGiftCoupon.maxDecrease);
                                  salaryAfterCoupon =
                                      totalPriceOfProducts - couponDecreaseRate;
                                  totalPriceIncludesTaxes -= couponDecreaseRate;
                                  hasCoupon = true;
                                  couponUsed.beforeDiscount =
                                      totalPriceOfProducts;
                                  couponUsed.afterDiscount = salaryAfterCoupon;
                                  couponUsed.couponID = yourGiftCoupon.couponID;

                                  if (mounted) setState(() {});
                                }

                                // here we will get the inputed coupon and do our operations.
                              },
                            ),
                          )
                        ],
                      ),
                      (hasCoupon == true)
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new RichText(
                            text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(
                                  text: translations.text(
                                      "PurchasePage.beforeCouponText"),
                                  style: new TextStyle(
                                      color: Colors.black,
                                      decoration:
                                      TextDecoration.lineThrough,
                                      decorationColor: Colors.red,
                                      fontSize:
                                      SizeConfig.getResponsiveWidth(
                                          15),
                                      decorationThickness: 3),
                                ),
                              ],
                            ),
                          ),
                          new RichText(
                            text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(
                                  text:
                                  "    ${double.parse(totalPriceOfProducts.toStringAsFixed(2))}",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      decoration:
                                      TextDecoration.lineThrough,
                                      decorationColor: Colors.red,
                                      fontSize:
                                      SizeConfig.getResponsiveWidth(
                                          15),
                                      decorationThickness: 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          : Container(),
                      (hasCoupon == false)
                          ? CustomListTile(
                          translations.text("PurchasePage.TotalSalaryText"),
                          "  "
                              "${double.parse(totalPriceOfProducts.toStringAsFixed(2))}")
                          : CustomListTile(
                          translations.text("PurchasePage.AfterCobonText"),
                          "  "
                              "${double.parse(salaryAfterCoupon.toStringAsFixed(2))}"),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(
                                  right: SizeConfig.getResponsiveWidth(10.0),
                                  left: (translations.currentLanguage == 'ar')
                                      ? SizeConfig.getResponsiveWidth(10)
                                      : 0),
                              child: new Text(
                                (translations.currentLanguage == 'ar')? "   الـمــنـطــقــة":"    region",
                                style: TextStyle(
                                    fontSize: SizeConfig.getResponsiveHeight(10.0)),
                              )),
                          DropdownButton<cities>(
                            hint: (translations.currentLanguage == 'ar')?
                            Text("قم بإخنيار المـديـنــة التابعه لك"):
                            Text("Choose Your City"),
                            value: selectedCities,
                            onChanged: (cities Value) {
                              setState(() {
                                selectedCities = Value;
                              });
                            },
                            items: regionLists.map((cities city) {
                              return  DropdownMenuItem<cities>(
                                value: city,
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_city),
                                    SizedBox(width: 10,),
                                    Text(
                                      (translations.currentLanguage == 'ar')?
                                      city.arabicTitle:
                                      city.title ,
                                      style:  TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )


                        ],
                      ),

//                      translations.currentLanguage == 'en'
//                          ? CustomListTile(
//                          "in time",
//                          "from " +
//                              today.day.toString() +
//                              "-" +
//                              today.month.toString() +
//                              "-" +
//                              today.year.toString())
//                          : CustomListTile(
//                          "سيصلك الطلب فى خلال مده",
//                          "من " +
//                              today.day.toString() +
//                              "-" +
//                              today.month.toString() +
//                              "-" +
//                              today.year.toString()),
//                      translations.currentLanguage == 'en'
//                          ? CustomListTile(
//                          "",
//                          "to " +
//                              orderDelivary.day.toString() +
//                              "-" +
//                              orderDelivary.month.toString() +
//                              "-" +
//                              orderDelivary.year.toString())
//                          : CustomListTile(
//                          "",
//                          "الى " +
//                              orderDelivary.day.toString() +
//                              "-" +
//                              orderDelivary.month.toString() +
//                              "-" +
//                              orderDelivary.year.toString()),

                      ListTile(
                        dense: true,
                        leading: Column(
                          children: <Widget>[
                            Text(
                              translations.text("PurchasePage.TotalText"),
                              style: TextStyle(
                                  fontSize:
                                  SizeConfig.getResponsiveHeight(9.0)),
                            ),
                            Text(
                              translations.text("PurchasePage.addedTaxes"),
                              style: TextStyle(
                                  fontSize:
                                  SizeConfig.getResponsiveHeight(7.0)),
                            )
                          ],
                        ),
                        trailing: (totalPriceOfProducts == null)
                            ? Center(
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ))
                            : Text(
                          "${double.parse(totalPriceIncludesTaxes.toStringAsFixed(2))} LE",
                          style: TextStyle(
                              fontSize:
                              SizeConfig.getResponsiveHeight(10.0)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Color.fromRGBO(229, 249, 239, 1),
              margin: EdgeInsets.only(
                  bottom: SizeConfig.getResponsiveHeight(120.0),
                  right: SizeConfig.getResponsiveWidth(90.0),
                  left: SizeConfig.getResponsiveWidth(90.0),
                  top: SizeConfig.getResponsiveHeight(10)),
              child: new FlatButton(
                padding: EdgeInsets.all(7.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
                child: new Text(
                  translations.text("PurchasePage.ReviewYourOrderButton"),
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
                  bottom: SizeConfig.getResponsiveHeight(10.0),
                  right: SizeConfig.getResponsiveWidth(120.0),
                  left: SizeConfig.getResponsiveWidth(120.0),
                  top: SizeConfig.getResponsiveHeight(10)),
              child: new FlatButton(
                  padding: EdgeInsets.all(7.0),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  color: Color(0XFF21d493),
                  child: new Text(
                    translations.text("PurchasePage.PurcharseButton"),
                    style: TextStyle(
                        fontSize: SizeConfig.getResponsiveHeight(15),
                        color: Colors.white),
                  ),
                  onPressed: () {
                    if (selectedCities == null) {
                      ////-- here shure that customer choose reigon
                      _showCupertinoDialog(context);
                    } else {
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(
                          builder: (context) =>
                          new PurchaseLocation(
                              hasCoupon: hasCoupon,
                              couponUsed: couponUsed,
                              customer: customer,
                              customerCities: selectedCities,
                              productsForOffer: widget.productsForOffer)));
                    }

                  }
              ),
            ),
          ]),
        );
      });
    });
  }

  void _showCupertinoDialog(BuildContext context) {
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
                    child: Icon(Icons.location_city,color: Colors.green,),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: translations.currentLanguage=='ar'?
                  Text("يجب اختيار المنطقه التابع اليها"):
                  Text( 'you must select a region',
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
}



Container CustomListTile(String text, String value) {
  return (value == null)
      ? Center(
      child: Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ))
      : Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(
                top: SizeConfig.getResponsiveHeight(5.0),
                bottom: SizeConfig.getResponsiveHeight(5.0),
                left: SizeConfig.getResponsiveWidth(10.0),
                right: SizeConfig.getResponsiveWidth(15.0)),
            child: new Text(
              text,
              style: TextStyle(
                  fontSize: SizeConfig.getResponsiveHeight(12.0)),
            )),
        Container(
            margin: EdgeInsets.only(
                right: SizeConfig.getResponsiveWidth(10.0),
                left: (translations.currentLanguage == 'ar')
                    ? SizeConfig.getResponsiveWidth(10)
                    : 0),
            child: new Text(
              value,
              style: TextStyle(
                  fontSize: SizeConfig.getResponsiveHeight(10.0)),
            ))
      ],
    ),
  );
}

double calculateCouponDecreaseRate(
    double totalPriceOfProducts, double decreaseRate, double maxDecrease) {
  double DecreaseRate = (totalPriceOfProducts * (decreaseRate / 100));
  if (maxDecrease < DecreaseRate) {
    DecreaseRate = maxDecrease;
  }
  return DecreaseRate;
}


