import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/offers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/screens/home_page/widgets/productSummary.dart';
import 'package:basket/utils/size_config.dart';

import '../product_profile.dart';

class productDetails extends StatefulWidget {
  Product currentProduct;
  offers offer;
  double newPrice = 0.0;
  bool hasOffer = false;
  productDetails(
      {this.currentProduct, this.offer, this.newPrice, this.hasOffer});
  @override
  _productDetailsState createState() => _productDetailsState();
}

var db = new DatabaseHelper();

class _productDetailsState extends State<productDetails> {
  int quantity = 0;
  @override
  void initState() {
    db.isProductFoundInBasketTable(widget.currentProduct.productId).then((val) {
      if (true) {
        db
            .getProductQuantityFromBasket(widget.currentProduct.productId)
            .then((val) {
          quantity = val;
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Color(0XFF21d493),
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(10.0)),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: SizeConfig.getResponsiveHeight(20),
                  ),
                ),
              ),
              title: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Text(translations.text("ProductDetailstPage.title"),
                      style: TextStyle(
                          fontSize: SizeConfig.getResponsiveHeight(15.0),
                          color: Colors.white))),
              elevation: 0.0,
            ),
            body: SafeArea(
                child: Container(
                    color: Color(0XFF21d493),
                    child: Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.getResponsiveHeight(60.0),
                                bottom: SizeConfig.getResponsiveHeight(5.0)),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 20.0,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10.0),
                                  width: SizeConfig.getResponsiveWidth(350.0),
                                  height: SizeConfig.getResponsiveHeight(450),
                                  child: ListView(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Container(
                                            margin:
                                                EdgeInsets.only(top: (120.0)),
                                            child: Center(
                                              child: Text(
                                                translations.currentLanguage ==
                                                        'en'
                                                    ? "${widget.currentProduct.title}"
                                                    : "${widget.currentProduct.arabicTitle}",
                                                style:
                                                    TextStyle(fontSize: (23.0)),
                                              ),
                                            ),
                                          ),
                                          (widget.hasOffer == true)
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: SizeConfig.getResponsiveWidth(10),
                                                    left: SizeConfig.getResponsiveWidth(10),
                                                      top: SizeConfig
                                                          .getResponsiveWidth(
                                                              20)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      new RichText(
                                                        text: new TextSpan(
                                                          children: <TextSpan>[
                                                            new TextSpan(
                                                              text:
                                                                  "${widget.currentProduct.price} " +
                                                                      "LE",
                                                              style: new TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  decorationColor:
                                                                      Colors
                                                                          .red,
                                                                  fontSize: SizeConfig
                                                                      .getResponsiveWidth(
                                                                          15),
                                                                  decorationThickness:
                                                                      3),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          right: SizeConfig.getResponsiveWidth(12.0),
                                                            left: SizeConfig
                                                                .getResponsiveWidth(
                                                                    12.0)),
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          "LE ${double.parse(widget.newPrice.toString()).toStringAsFixed(2)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: SizeConfig
                                                                .getResponsiveWidth(
                                                                    15),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      top: (4.0)),
                                                  child: Center(
                                                    child: Text(
                                                      "LE ${widget.currentProduct.price.toString()}",
                                                      style: TextStyle(
                                                          fontSize: (15.0)),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: SizeConfig.getResponsiveWidth(45.0)),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: SizeConfig.getResponsiveWidth(20.0), bottom: SizeConfig.getResponsiveWidth(15.0)),
                                              child: Text(
                                                translations.text(
                                                    "ProductDetailstPage.ProductQuantity"),
                                                style:
                                                    TextStyle(fontSize: SizeConfig.getResponsiveWidth(17.0)),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 25.0,
                                                  width: 25.0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      int currentQuantity =
                                                          quantity;
                                                      quantity =
                                                          currentQuantity + 1;
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    child: Center(
                                                        child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                          fontSize: 20.0),
                                                    )),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 2)),
                                                ),
                                                Container(
                                                  width: 30.0,
                                                  margin: EdgeInsets.only(
                                                      right: 10.0, left: 10.0),
                                                  child: Center(
                                                      child: Text(
                                                    quantity.toString(),
                                                    style: TextStyle(
                                                        fontSize: 20.0),
                                                  )),
                                                ),
                                                Container(
                                                  height: 25.0,
                                                  width: 25.0,
                                                  child: InkWell(
                                                    onTap: () {
                                                      int currentQuantity =
                                                          quantity;
                                                      if (currentQuantity - 1 >=
                                                          0) {
                                                        quantity =
                                                            currentQuantity - 1;
                                                        if (mounted) {
                                                          setState(() {});
                                                        }
                                                      }
                                                    },
                                                    child: Center(
                                                        child: Text(
                                                      "-",
                                                      style: TextStyle(
                                                          fontSize: 20.0),
                                                    )),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(width: 2)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 15.0, left: 15.0),
                                            child: new FlatButton(
                                              padding: EdgeInsets.all(7.0),
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0)),
                                              color: Color(0XFF21d493),
                                              child: new Text(
                                                translations.text(
                                                    "ProductDetailstPage.AddToCartButton"),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              onPressed: (quantity != 0)
                                                  ? () {
                                                      _showCupertinoDialog(context);
                                                    }
                                                  : () {
                                                      //TODO change add (يجب وضغ المنتج فى سله العائله)
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(SnackBar(
                                                              content:
                                                              Text( 'you must add product to card')));
                                                    },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 15.0, left: 15.0),
                                            child: new FlatButton(
                                              padding: EdgeInsets.all(7.0),
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0)),
                                              color: Color(0XFF21d493),
                                              child: new Text(
                                                translations.text(
                                                    "ProductDetailstPage.SeeDetailsButton"),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.push(context,SlideRightRoute(page: productProfile(
                                                    currentProduct:
                                                    widget
                                                        .currentProduct)));

                                              },
                                            ),
                                          ),
                                        ],
                                      ),

//                                      registrationButton()
                                    ],
                                  ),
                                )),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 70.0, right: 70),
                              width: 220.0,
                              height: 200.0,
                              child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: productSummaryCard(
                                    product: widget.currentProduct,
                                  ))),
                        ],
                      ),
                    ))));
      });
    });
  }

  ////--- this alert Dialog for conifrmation adding Product to My Basket
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
                    backgroundImage: AssetImage("assets/images/true.png"),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(5),
                  child: Text(
                    translations.text("ProductDetailstPage.AlertDialogText"),
                    style: TextStyle(fontSize: 18.0),
                  ), /////////localiz
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    RaisedButton(
                      color: Color.fromRGBO(33, 212, 147, 1),
                      onPressed: () async {
                        await db.addProductIntoBasket(
                            widget.currentProduct.productId,
                            widget.currentProduct.categoryId,
                            quantity,

                        );
                        _dismissDialog(context);
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
                        _dismissDialog(context);
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
          );
        });
  }
}

_dismissDialog(BuildContext context) {
  Navigator.pop(context);
}
//// -- for animation on Naviagtion (when i clisk product to move details )
class SlideRightRoute extends PageRouteBuilder {
  final Widget page;

  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),  /// 1,0 right  // 1,1 right bottom // -1,1 left bottom // -1,0 left
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}