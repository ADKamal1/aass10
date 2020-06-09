import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/offerProducts.dart';
import 'package:basket/_model/offers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/utils/size_config.dart';

import 'widgets/offer_cart.dart';

class OfferScreen extends StatefulWidget {
  _OfferScreenState createState() => new _OfferScreenState();
}

class _OfferScreenState extends State<OfferScreen> {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName = "offers";
  String nodeCategory = "category";

  List<offers> offers_list = <offers>[];
  List<offerProducts> offer_products = <offerProducts>[];
  List<Product_Offer> productsForOffer = <Product_Offer>[];

  List<offers> offerList = <offers>[];
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
                print(" from offer productarabicTitle = " + nextProduct.arabicTitle);
                SizedBox(
                  width: double.infinity,
                  child:
                  CachedNetworkImage(
                    placeholder: (context, url) => const AspectRatio(
                      aspectRatio: 1.6,
                    ),
                    imageUrl:nextProduct.photo,
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

  @override
  void initState() {
    getOfferList();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.getResponsiveHeight(15),
                  bottom: SizeConfig.getResponsiveHeight(20.0)),
              width: SizeConfig.getResponsiveWidth(90.0),
              height: SizeConfig.getResponsiveHeight(100.0),
              child: Center(
                child: Image.asset(
                  "assets/images/offer.png",
                ),
              ),
            ),
            Container(
              margin:
                  EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(0.0)),
              child: GridView.count(
                mainAxisSpacing: SizeConfig.getResponsiveHeight(0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                childAspectRatio: 1.0,
                crossAxisSpacing: SizeConfig.getResponsiveWidth(0.0),
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 540 ? 3 : 2,
                children: List.generate(
                    productsForOffer.length, (index) {

                    double newPrice = productsForOffer[index].product.price *
                        (productsForOffer.elementAt(index).offer.rate/100);;
                    return makeProductCard(
                        productsForOffer[index].product ,
                        productsForOffer[index].offer  , newPrice);

                }),
              ),
            )
          ],
        );
      });
    });
  }
  // if the product has offer it will return the id else will return -1
  int ifProductHaveOffer(String productID){

    for(int i = 0 ; i < productsForOffer.length ;i++){
      if(productsForOffer.elementAt(i).product.productId == productID){
        return  i;
      }
    }
    return -1;
  }
}


Widget makeProductCard(Product productItem , offers offerItem , double newPrice) {
  return Container(
    child:
        FittedBox(fit: BoxFit.contain, child: OfferCard(
            product: productItem , offer:offerItem, newPrice:newPrice)),
  );
}
