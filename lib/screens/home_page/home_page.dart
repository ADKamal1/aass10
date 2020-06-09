import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/categories.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/home_page/favourite_screen.dart';
import 'package:basket/screens/home_page/my_Basket.dart';
import 'package:basket/screens/home_page/offer_screen.dart';
import 'package:basket/screens/home_page/profile.dart';
import 'package:basket/screens/home_page/widgets/appbar.dart';
import 'package:basket/screens/home_page/widgets/side_menu.dart';
import 'package:basket/screens/purchase/purchase.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'store.dart';
import 'widgets/navigation.dart';

class HomePage extends StatefulWidget {
  Widget screen = Container();
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  HomePage({this.screen, this.auth, this.onSignedOut});

  _HomePage createState() => new _HomePage();
}

//List<Product> productList = <Product>[];
List<categories> categoryList = <categories>[];

class _HomePage extends State<HomePage> {
  customers authenticatedCustomer;
  bool isAuthenticated = false;

  ////- for Pagainition
  Product last;
  int perpage = 20;

  refresh() {
    if (mounted)
      setState(() {
        navigationIdx = 1;
      });
  }

  FirebaseDatabase _database = FirebaseDatabase.instance;

  /////--- Notifications
  /// --  Notifications
  String textValue = 'use to assign token value for that delivary men';
  FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  showNotification(Map<String, dynamic> msg) async {
    var android = new AndroidNotificationDetails(
      'sdffds dsffds',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(
        0, "This is title", "this is demo", platform); //// title bodey in Local
  }

  update(String token1) async {
    print(token1);
    DatabaseReference databaseReference = new FirebaseDatabase().reference();
    databaseReference
        .child('customers/${authenticatedCustomer.customerID}')
        .set(
      {
        "token": token1,
        "email": authenticatedCustomer.email,
        "gender": "male",
        "isBlocked": false,
        "name": authenticatedCustomer.name,
        "latitude": authenticatedCustomer.customerLat,
        "longitude": authenticatedCustomer.customerLong,
        "phone": authenticatedCustomer.phone
      },
    );
    textValue = token1;
    setState(() {});

    databaseReference.child('fcm-token/${authenticatedCustomer.token}').set(
      {
        "customerID": authenticatedCustomer.customerID,
      },
    );

    //// for update Token For that Customer ID in tokens Table
    // get the orders for the user..

//    fcmTokens token;
//    await _database
//        .reference()
//        .child("fcm-token")
//        .orderByChild("customerID")
//        .equalTo(authenticatedCustomer.customerID)
//        .once()
//        .then((DataSnapshot snapshot) {
//      token = fcmTokens.fromSnapshot(snapshot);
//      if (mounted) {
//        setState(() {});
//      }
//    });
//    if(token!=null){
//      await _database
//          .reference()
//          .child("fcm-token")
//          .child(authenticatedCustomer.customerID)
//          .remove()
//          .then((_) {}).whenComplete(() => {
//      //DatabaseReference databaseReference1 = new FirebaseDatabase().reference();
//      databaseReference.child('fcm-token/${authenticatedCustomer.token}').set({
//      "customerID": authenticatedCustomer.customerID,
//      },)
//      });
//      print("\n\n\n + aaaa");
//
//    }
//    else{
//      //DatabaseReference databaseReference1 = new FirebaseDatabase().reference();
//      databaseReference.child('fcm-token/${authenticatedCustomer.token}').set({
//        "customerID": authenticatedCustomer.customerID,
//      },);
//
//      print("\n\n\n + bbbbbb");
//
//    }
  }

  ForStrartNotifications() {
    if (isAuthenticated) {
      ///- Notifications
      var android = new AndroidInitializationSettings('mipmap/ic_launcher');
      var ios = new IOSInitializationSettings();
      var platform = new InitializationSettings(android, ios);
      flutterLocalNotificationsPlugin.initialize(platform);

      firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> msg) {
          print(" onLaunch called ${(msg)}");
        },
        onResume: (Map<String, dynamic> msg) {
          print(" onResume called ${(msg)}");
        },
        onMessage: (Map<String, dynamic> msg) {
          showNotification(msg);
          print(" onMessage called ${(msg)}");
        },
      );
      firebaseMessaging.requestNotificationPermissions(
          const IosNotificationSettings(sound: true, alert: true, badge: true));
      firebaseMessaging.onIosSettingsRegistered
          .listen((IosNotificationSettings setting) {
        print('IOS Setting Registed');
      });
      firebaseMessaging.getToken().then((token) {
        update(token);
      });
    }
  }

  initState() {
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
        // usser is authenticated..
      } else {
        isAuthenticated = false;
      }
    }).whenComplete(() => {
          ForStrartNotifications(),
        });

//    ForStrartNotifications();
    //  getAllProducts();
    getAllCategories();
    //if (mounted) setState(() {});
  }

  var _isInit = true;
  var _isLoading = false;

  List<Product> productList = <Product>[];
  //final productList = [];
  @override
  /*void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }*/

//  getAllProducts() async{
//    productList.clear();
//    // get the products
//    await _database.reference()
//        .child("products")
//        .orderByChild("title")
//        .limitToFirst(40)
//        .once()
//        .then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> productsMap = snapshot.value;
//      productsMap.forEach((key, value) async{
//        Product p = Product.fromMap(value , key);
//        productList.add(p);
//      });
//    }).then((v) {
//      if (mounted) setState(() {});
//    });
//    last = productList[40];
//  }
//
//  getMoorProducts() async {
//    //productList.clear();
//    // get the products
//    await _database
//        .reference()
//        .child("products")
//        .orderByChild("title")
//        .limitToLast(perpage)
//        .startAt(last)
//        .once()
//        .then((DataSnapshot snapshot) {
//      Map<dynamic, dynamic> productsMap = snapshot.value;
//      productsMap.forEach((key, value) async {
//        Product p = Product.fromMap(value, key);
//        productList.add(p);
//      });
//    }).then((v) {
//      if (mounted) setState(() {});
//    });
//    last = productList[40 + perpage - 1];
//  }

  getAllCategories() async {
    //   categoryList.clear();
    await _database
        .reference()
        .child("categories")
        .once()
        .then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> categori = snapshot.value;
      categori.forEach((key, value) async {
        categories nextCategories = categories.fromMap(value, key);

        categoryList.add(nextCategories);
      });
    }).then((e) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  int navigationIdx = 0;
  Widget currentScreen = new Store(
    categoryList: categoryList,
    //productList:productList,
  );
  Widget purchase = new Purchase();
  int aa = 0;

  @override
  Widget build(BuildContext context) {
    print("\n\n + aaa");

    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          key: _scaffoldKey,
          body: Stack(children: <Widget>[
            currentScreen,
//            aa==0?
//            Positioned(
//              bottom: 65,
//              right: 0,
//              child: FloatingActionButton(
//                autofocus: true,
//                highlightElevation: 30,
//                isExtended: true, hoverElevation: 20,
//                hoverColor: Colors.black12,
//                onPressed: () {
//                  setState(() {
//                    getMoorProducts();
//                  });
//                  print(productList.length);
//                },
//
//                backgroundColor: Colors.lightGreen,
//
//                child: Text(translations.text("HomePage.bottomNavigationMoor")),
//                elevation: 20,
//                //shape: ,
//              ),
//            ):Container(),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(SizeConfig.getResponsiveWidth(40)),
                  topLeft: Radius.circular(SizeConfig.getResponsiveWidth(40)),
                ),
                child: BottomNavigationBar(
                  currentIndex: navigationIdx,
                  elevation: 40.0,
                  items: [
                    bottomNavigationBarItem(
                        "assets/images/store-icon.png",
                        "assets/images/store-icon.png",
                        translations.text("HomePage.bottomNavigationStore")),
                    bottomNavigationBarItem(
                        "assets/images/sala.png",
                        "assets/images/sala.png",
                        translations.text("HomePage.bottomNavigationCart")),
                    bottomNavigationBarItem(
                        "assets/images/offer_icon.png",
                        "assets/images/offer_icon.png",
                        translations.text("HomePage.bottomNavigationOffers")),
                    bottomNavigationBarItem(
                        "assets/images/heardw.png",
                        "assets/images/heardw.png",
                        translations
                            .text("HomePage.bottomNavigationFavourite")),
                    bottomNavigationBarItem(
                        "assets/images/profile.png",
                        "assets/images/profile.png",
                        translations.text("HomePage.bottomNavigationProfile"))
                  ],
                  onTap: (index) {
                    navigationIdx = index;
                    currentScreen = getCurrentScreen(index);

                    setState(() {
//                      getMoorProducts();
//                      perpage += 10;
                    });
                  },
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.green,
                  showUnselectedLabels: true,
                ),
              ),
            ),
          ]),
          appBar: getPageAppbar(_scaffoldKey, navigationIdx),
          drawer: SideMenu(
            parentContext: context,
            auth: widget.auth,
          ),
        );
      });
    });
  }

  Widget getCurrentScreen(int idx) {
    if (idx == 0) {
      aa = 0;
      return Store(categoryList: categoryList);
    } else if (idx == 1) {
      return new myBasket(
        productList: productList,
        auth: widget.auth,
      );
    } else if (idx == 2) {
      return new OfferScreen();
    } else if (idx == 3) {
      return new FavouriteScreen(productList: productList);
    } else {
      return new Profile(
        // notifyParent: refresh,
        auth: widget.auth,
      );
    }
  }
}

AppBar getPageAppbar(GlobalKey<ScaffoldState> _scaffoldKey, int navigationIdx) {
  if (navigationIdx != 4)
    return myCartAppbar(_scaffoldKey, getTitleAppBarWidget(navigationIdx));
}

Widget getTitleAppBarWidget(int idx) {
  if (idx == 1) {
    return Text(translations.text("HomePage.bottomNavigationCart"));
  } else {
    return Container();
  }
}
