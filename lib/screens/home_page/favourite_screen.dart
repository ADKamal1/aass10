import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/offerProducts.dart';
import 'package:basket/_model/offers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/_model/favouritex.dart';
import 'package:basket/screens/home_page/widgets/product_details.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';
import '../../database/database_helper.dart';

class FavouriteScreen extends StatefulWidget {
  List<Product> productList = <Product>[];
  FavouriteScreen({this.productList });
  _FavouriteScreenState createState() => new _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {

  ////- for products has Offer in Favourite screen
  List<offers> offers_list = <offers>[];
  List<offerProducts> offer_products = <offerProducts>[];
  List<Product_Offer> productsForOffer = <Product_Offer>[];


  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeCategory = "category";
  List<Product> favouriteList = <Product>[];


  void getProductsFromFavourite() async {
    var db = new DatabaseHelper();
    favouriteList.clear();

    List<Favourite> favourites = await db.getAllProductPaths();
     print("favourite products = " + favourites.length.toString());
      for(int j = 0 ; j < favourites.length ; j++){
        for (int i = 0; i < widget.productList.length; i++) {
          if(favourites[j].productPath == widget.productList[i].productId){
            favouriteList.add(widget.productList[i]);
            break;
          }
        }
      }
      if(mounted){setState(() {});}

  }
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
     getProductsFromFavourite();
     if(mounted){setState(() {});}
  }

  var favouriteService = new FavouriteServices();
  @override
  Widget build(BuildContext context) {

    Color favouriteColor = Colors.grey;
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return ListView(
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
            (favouriteList.length == 0)?Center(
                child: Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.getResponsiveHeight(100.0)),
                    child: Text(translations.text("FavouritePage.NoItemAdded"),
                      style: TextStyle(fontSize: SizeConfig.getResponsiveWidth(20), color: Colors.grey),
                    )))
           : Container(
              margin:
                  EdgeInsets.only(bottom: SizeConfig.getResponsiveHeight(50.0)),
              child: GridView.count(
                mainAxisSpacing: SizeConfig.getResponsiveHeight(0),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                childAspectRatio: 1.0,
                crossAxisSpacing: SizeConfig.getResponsiveWidth(0.0),
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 540 ? 3 : 2,
                children: List.generate(favouriteList.length, (index) {
                  bool hasOffer = false;
                  double newPrice = 0.0;
                  int produ = ifProductHaveOffer(favouriteList[index].productId);
                  Product product = favouriteList.elementAt(index);
                  if(produ != -1) {
                    newPrice =
                        favouriteList[index].price * (productsForOffer
                            .elementAt(produ)
                            .offer
                            .rate / 100);
                    hasOffer = true;
                  }

                  return FittedBox(
                    fit: BoxFit.contain,
                    child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                            margin: EdgeInsets.only(right: 20.0, left: 10.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              color: Colors.white,
                              elevation: 3,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: SizeConfig.getResponsiveHeight(
                                                10.0),
                                            left: SizeConfig.getResponsiveWidth(
                                                translations.currentLanguage=='en'?5:80.0),
                                            right:
                                            (translations.currentLanguage=='ar')?SizeConfig.getResponsiveWidth(
                                                30):SizeConfig.getResponsiveWidth(
                                                    80)),
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(5.0))),
                                        width: SizeConfig.getResponsiveWidth(
                                            100.0),
                                        height: SizeConfig.getResponsiveHeight(
                                            30.0),
                                        child: Center(
                                          child: FittedBox(
                                            fit: BoxFit.cover,
                                            child: Text(translations.currentLanguage=='en'?
                                              "${product.englishQuantityType}":"${product.arabicQuantityType}",
                                              style: new TextStyle(
                                                  color: Colors.white70,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig
                                                      .getResponsiveWidth(
                                                          25.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.all(15.0),
                                          child: new InkWell(
                                              onTap: () async {
                                                int x = await favouriteService
                                                    .triggerFavourite(
                                                        product.productId,
                                                        product.categoryId);
                                                await getProductsFromFavourite();
                                                if (mounted) setState(() {});
                                              },
                                              child: FutureBuilder<int>(
                                                future: favouriteService
                                                    .getFavouriteStatus(
                                                        product.productId,
                                                        product.categoryId),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<int>
                                                        snapshot) {
                                                  int x = snapshot.data;
                                                  favouriteColor = (x == 1)
                                                      ? Colors.red
                                                      : Colors.grey;
                                                  return new Icon(
                                                    Icons.favorite,
                                                    color: favouriteColor,
                                                    size: SizeConfig
                                                        .getResponsiveHeight(
                                                            45.0),
                                                  );
                                                },
                                              )))
                                    ],
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (context) =>  new productDetails(currentProduct: product)));
                                      },
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Container(
                                          padding: EdgeInsets.only(right: 4,left: 4),
                                          height: SizeConfig.getResponsiveHeight(160.0),
                                          width: SizeConfig.getResponsiveWidth(250.0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child:
                                            CachedNetworkImage(
                                              placeholder: (context, url) => const AspectRatio(
                                                aspectRatio: 1.6,
                                              ),
                                              imageUrl:product.photo,
                                              fit: BoxFit.contain,
                                            ),
                                          )//                          child: Image.asset(
                                        ),
                                      )),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            right:(translations.currentLanguage == 'ar')?
                                            SizeConfig.getResponsiveWidth(50):
                                                SizeConfig.getResponsiveWidth(
                                                    5.0)),
                                        child: Text(
                                          (translations.currentLanguage == 'en')?
                                          "${product.title}":"${product.arabicTitle}",
                                          maxLines: 3,

                                          //   overflow:TextOverflow. ,
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.getResponsiveWidth(
                                                      20.0),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),(hasOffer == true)?Container(
                                        margin: EdgeInsets.only(
                                            left:SizeConfig.getResponsiveWidth(10) , right:SizeConfig.getResponsiveWidth(10)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new RichText(
                                              text: new TextSpan(

                                                children: <TextSpan>[
                                                  new TextSpan(

                                                    text: "${product.price.toString()} " + "LE" ,
                                                    style: new TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        decoration: TextDecoration.lineThrough,
                                                        decorationColor: Colors.red,
                                                        fontSize: SizeConfig.getResponsiveWidth(15),
                                                        decorationThickness: 3
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: SizeConfig.getResponsiveWidth(12.0),

                                                  left: SizeConfig.getResponsiveWidth(12.0)),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "LE ${double.parse(newPrice.toString()).toStringAsFixed(2)}",
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: SizeConfig.getResponsiveWidth(15),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: (translations.currentLanguage == 'ar')?SizeConfig.getResponsiveWidth(120.0):SizeConfig.getResponsiveWidth(10.0),
                                                  left:(translations.currentLanguage == 'ar')? SizeConfig.getResponsiveWidth(0.0): SizeConfig.getResponsiveWidth(100.0),
                                                  bottom: SizeConfig.getResponsiveHeight(10.0)),
                                              child: Icon(
                                                Icons.shopping_basket,
                                                color: Colors.green,
                                                size: SizeConfig.getResponsiveHeight(35),
                                              ),
                                            )
                                          ],
                                        ),
                                      ):
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: SizeConfig
                                                    .getResponsiveWidth(12.0)),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "LE ${product.price.toString()}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: SizeConfig
                                                    .getResponsiveWidth(15),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              right:(translations.currentLanguage == 'ar')?SizeConfig.getResponsiveWidth(140):0,
                                                left: (translations.currentLanguage == 'ar')?SizeConfig.getResponsiveWidth(0):SizeConfig
                                                    .getResponsiveWidth(140.0),
                                                bottom: SizeConfig
                                                    .getResponsiveHeight(10.0)),
                                            child: Icon(
                                              Icons.shopping_basket,
                                              color: Colors.green,
                                              size: SizeConfig
                                                  .getResponsiveHeight(35),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ))),
                  );
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

