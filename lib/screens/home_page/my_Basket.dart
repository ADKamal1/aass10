import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/favouritex.dart';
import 'package:basket/_model/offerProducts.dart';
import 'package:basket/_model/offers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/home_page/widgets/productsForSpecificCategory.dart';
import 'package:basket/screens/purchase/purchase.dart';
import 'package:basket/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../entryScreens/root_page.dart';
import 'widgets/productBasket_card.dart';

class myBasket extends StatefulWidget {
  final BaseAuth auth;

  List<Product> productList = <Product>[];
  myBasket({this.productList, this.auth});
  _myBasketState createState() => new _myBasketState();
}

class _myBasketState extends State<myBasket> {
  //// --- to know coustomer authenticated or not (and get his informations)
  customers authenticatedCustomer;
  bool isAuthenticated = false;
  getCurrentUser() {
    FirebaseAuth.instance.currentUser().then((user) async {
      if (user != null) {
        String userId = user.uid;
        isAuthenticated = true;
        await FirebaseDatabase.instance
            .reference()
            .child("customers")
            .child(userId)
            .once()
            .then((DataSnapshot snapshot) {
          authenticatedCustomer = customers.fromSnapshot(snapshot);
        });
      } else {
        isAuthenticated = false;
      }
    }).then((d) {
      if (mounted) setState(() {});
    });
  }

  ////- for products has Offer in My basket screen
  List<offers> offers_list = <offers>[];
  List<offerProducts> offer_products = <offerProducts>[];
  List<Product_Offer> productsForOffer = <Product_Offer>[];
  void getOfferList() async {
    productsForOffer.clear();
    offer_products.clear();
    offers_list.clear();
    await _database
        .reference()
        .child("offerProducts")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> productsMap = snapshot.value;
      productsMap.forEach((key, value) {
        offer_products.add(offerProducts.fromMap(value, key));
      });
    }).whenComplete(() {
      _database
          .reference()
          .child("offers")
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> productsMap = snapshot.value;
        productsMap.forEach((key, value) {
          offers_list.add(offers.fromMap(value, key));
        });
      }).whenComplete(() {
        for (var offer in offer_products) {
          offers newOffer = new offers();
          Product nextProduct = new Product();
          for (var of in offers_list) {
            if (offer.offerID == of.offerID) {
              newOffer = of;
              _database
                  .reference()
                  .child("products")
                  .child(offer.productID)
                  .once()
                  .then((DataSnapshot snapshot) async {
                nextProduct = Product.fromMap(snapshot.value, snapshot.key);
                print(" from offer productarabicTitle = " +
                    nextProduct.arabicTitle);
                SizedBox(
                  width: double.infinity,
                  child: CachedNetworkImage(
                    placeholder: (context, url) => const AspectRatio(
                      aspectRatio: 1.6,
                    ),
                    imageUrl: nextProduct.photo,
                    fit: BoxFit.contain,
                  ),
                );
              }).whenComplete(() {
                productsForOffer.add(new Product_Offer(newOffer, nextProduct));
                if (mounted) setState(() {});
              });
            }
          }
        }
      });
    });
  }

  var db = new DatabaseHelper();
  FirebaseDatabase _database = FirebaseDatabase.instance;
  List<Favourite> basketList = <Favourite>[];
  List<Product> basketProductList = <Product>[];
  bool empty = false;

  @override
  void initState() {
    super.initState();
    getOfferList();
    getCurrentUser();
    getBasketProducts();
    print("initialize");
  }

  refresh() async {
    await getAllBasketProductPathsFromDatabase();

    for (int i = 0; i < basketProductList.length; i++) {
      bool found = false;
      for (var productInDB in basketList) {
        if (basketProductList.elementAt(i).productId ==
            productInDB.productPath) {
          found = true;
          break;
        }
      }
      if (found == false) {
        basketProductList.removeAt(i);
      }
    }
    if (mounted) setState(() {});
  }

  getAllBasketProductPathsFromDatabase() async {
    basketList.clear();
    await db.getAllBasketProductPaths().then((value) {
      basketList = value;
      if (basketList.length == 0) {
        empty = true;
      }
      setState(() {});
    });
  }

  int ifProductHaveOffer(String productID) {
    for (int i = 0; i < productsForOffer.length; i++) {
      if (productsForOffer.elementAt(i).product.productId == productID) {
        return i;
      }
    }
    return -1;
  }

  getBasketProducts() async {
    basketProductList.clear();
    await getAllBasketProductPathsFromDatabase();

    for (int i = 0; i < basketList.length; i++) {
//        for(int j =  0 ; j < productList.length ; j++){
//            if(basketList.elementAt(i).productPath == productList.elementAt(j).productId){
//              basketProductList.add(productList.elementAt(j));
//              break;
//            }
//        }
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.getResponsiveHeight(10),
                  bottom: SizeConfig.getResponsiveHeight(15.0)),
              width: SizeConfig.getResponsiveWidth(80.0),
              height: SizeConfig.getResponsiveHeight(90.0),
              child: Center(
                child: Image.asset(
                  "assets/images/sala.png",
                  color: Colors.green,
                ),
              ),
            ),
            (empty == true)
                ? Center(
                    child: Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.getResponsiveHeight(500),
                            top: SizeConfig.getResponsiveHeight(100.0)),
                        child: Text(
                          translations.text("MyBasketPage.NoItemhasAdded"),
                          style: TextStyle(fontSize: 25, color: Colors.grey),
                        )))
                : ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: SizeConfig.getResponsiveHeight(20.0)),
                        child: GridView.count(
                          mainAxisSpacing: SizeConfig.getResponsiveHeight(0),
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          childAspectRatio: 1.0,
                          crossAxisSpacing: SizeConfig.getResponsiveWidth(0.0),
                          crossAxisCount:
                              MediaQuery.of(context).size.width >= 540 ? 3 : 2,
                          children:
                              List.generate(basketProductList.length, (ind) {
                            int productOffer = ifProductHaveOffer(
                                basketProductList[ind].productId);

                            if (productOffer == -1) {
                              return Container(
                                height: SizeConfig.getResponsiveHeight(70.0),
                                width: SizeConfig.getResponsiveWidth(80.0),
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: productBasketCard(
                                      notifyParent: refresh,
                                      product: basketProductList.elementAt(ind),
                                      hasOffer: false,
                                      newPrice: 0.0,
                                    )),
                              );
                            } else {
                              double newPrice = basketProductList[ind].price *
                                  (productsForOffer
                                          .elementAt(productOffer)
                                          .offer
                                          .rate /
                                      100);
                              return Container(
                                height: SizeConfig.getResponsiveHeight(70.0),
                                width: SizeConfig.getResponsiveWidth(80.0),
                                child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: productBasketCard(
                                      notifyParent: refresh,
                                      product: basketProductList.elementAt(ind),
                                      hasOffer: true,
                                      newPrice: newPrice,
                                    )),
                              );
                            }
                          }),
                        ),
                      ),
                      (empty == true)
                          ? Center(
                              child: Container(
                                  child: Text(translations
                                      .text("BasketPage.NoItemText"))),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.getResponsiveHeight(200.0),
                                  right: SizeConfig.getResponsiveWidth(100.0),
                                  left: SizeConfig.getResponsiveWidth(100.0)),
                              child: new FlatButton(
                                padding: EdgeInsets.all(7.0),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                                color: Color(0XFF21d493),
                                child: new Text(
                                  translations
                                      .text("BasketPage.MakeOrderButton"),
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.getResponsiveWidth(15),
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  if (isAuthenticated == false) {
                                    Navigator.of(context)
                                        .push(new MaterialPageRoute(
                                            builder: (context) => new RootPage(
                                                  auth: new Auth(),
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        SlideRightRoute(
                                            page: Purchase(
                                          productsForOffer: productsForOffer,
                                        )));
                                  }
                                },
                              ),
                            )
                    ],
                  )
          ],
        ));
      });
    });
  }
}

Widget makeProductCard(Product productItem, bool hasOffer, double newPrice) {
  return Container(
    height: SizeConfig.getResponsiveHeight(70.0),
    width: SizeConfig.getResponsiveWidth(80.0),
    child: FittedBox(
        fit: BoxFit.contain,
        child: productsForSpecificCategory(
            product: productItem, hasOffer: hasOffer, newPrice: newPrice)),
  );
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
              begin: const Offset(1, 0),

              /// 1,0 right  // 1,1 right bottom // -1,1 left bottom // -1,0 left
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
