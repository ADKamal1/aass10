import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/Providers/products.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/favouritex.dart';
import 'package:basket/_model/offerProducts.dart';
import 'package:basket/_model/offers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/utils/size_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../_model/categories.dart';
import 'widgets/categoryTitle.dart';
import 'widgets/main_card.dart';
import 'widgets/productCard.dart';
import 'widgets/storeHeader.dart';

class Store extends StatefulWidget {
  final Function() notifyParent;
  //List<Product> productList =  <Product>[];
  List<categories> categoryList = <categories>[];
  Store({Key key, this.categoryList, @required this.notifyParent})
      : super(key: key);
  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
//  Future<void> _refreshProducts(BuildContext context) async {
//    await Provider.of<Products>(context).fetchAndSetProducts();
//  }

  ////- for products has Offer All proudects
  FirebaseDatabase _database = FirebaseDatabase.instance;
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
                    fit: BoxFit.cover,
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

  String nodeName = "products";
  String nodeCategory = "category";
  String nodeOfferName = "offers";
  List<Favourite> favouriteList = <Favourite>[];

  var _isInit = true;
  var _isLoading = false;

  List<Product> productList = <Product>[];

  @override
  @override
  void initState() {
    super.initState();
    getOfferList();
  }

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      //categoryList;
    }
    _isInit = false;
    _isLoading = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    productList.clear();
    super.dispose();
  }

  var db = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(this.context);
    productList = productsData.items;
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Container(
            margin:
                EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(60.0)),
            child: Stack(children: <Widget>[
              new ListView(children: <Widget>[
                StoreHeader(),
                Container(
                  margin: EdgeInsets.only(
                      bottom: 0.781 * SizeConfig.heightMultiplier),
                  height: 18.55 * SizeConfig.heightMultiplier,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.categoryList.length,
                    itemBuilder: (context, index) {
                      print("categoruy item length = " +
                          widget.categoryList.length.toString());
                      //TODO change
                      List<Product> categoryItems =
                          getListProductOfSpecificCategory(
                              widget.categoryList[index].categoryID);
                      print("categoryItems item length = " +
                          categoryItems.length.toString());
                      return (categoryItems.length == 0)
                          ? Container()
                          : mainCard(
                              category: widget.categoryList[index],
                              title: translations.currentLanguage == 'en'
                                  ? widget.categoryList[index].title
                                  : widget.categoryList[index].arabicTitle,
                              productsForOffer: productsForOffer,
                              categoryItems: getListProductOfSpecificCategory(
                                  widget.categoryList[index].categoryID),
                            );
                    },
                  ),
                ),
                new ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.categoryList.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      String categoryId = widget.categoryList[index].categoryID;
                      List<Product> renderProducts =
                          getListProductOfSpecificCategory(categoryId);
                      return (renderProducts.length == 0)
                          ? Container()
                          : new Container(
                              child: Column(
                              children: <Widget>[
                                CategoryTitle(
                                    categoryName:
                                        translations.currentLanguage == 'en'
                                            ? widget.categoryList[index].title
                                            : widget.categoryList[index]
                                                .arabicTitle,
                                    categoryItems:
                                        getListProductOfSpecificCategory(widget
                                            .categoryList[index].categoryID),
                                    productsForOffer: productsForOffer),
                                Container(
                                  height: 24.4 * SizeConfig.heightMultiplier,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: renderProducts.length,
                                    itemBuilder: (context, ind) {
                                      int productOffer = ifProductHaveOffer(
                                          renderProducts[ind].productId);
                                      if (productOffer == -1) {
                                        return buildProduct_card(
                                            renderProducts[ind], false, 0.0);
                                      } else {
                                        double newPrice =
                                            renderProducts[ind].price *
                                                (productsForOffer
                                                        .elementAt(productOffer)
                                                        .offer
                                                        .rate /
                                                    100);
                                        return buildProduct_card(
                                            renderProducts[ind],
                                            true,
                                            newPrice);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ));
                    }),
              ]),
            ]));
      });
    });
    productList.clear();
  }

  // if the product has offer it will return the id else will return -1
  int ifProductHaveOffer(String productID) {
    for (int i = 0; i < productsForOffer.length; i++) {
      if (productsForOffer.elementAt(i).product.productId == productID) {
        return i;
      }
    }
    return -1;
  }

  product_card buildProduct_card(
      Product myproduct, bool hasOffer, double newPrice) {
    return product_card(
        product: myproduct, hasOffer: hasOffer, newPrice: newPrice);
  }

  List<Product> getListProductOfSpecificCategory(String categoryId) {
    List<Product> productOfCategory = <Product>[];
    for (var pro in productList) {
      if (pro.categoryId == categoryId) {
        productOfCategory.add(pro);
      }
    }
    return productOfCategory;
  }
}
