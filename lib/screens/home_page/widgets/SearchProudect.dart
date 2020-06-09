import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/favouritex.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/screens/home_page/widgets/product_details.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';

class searchProduct extends StatefulWidget {
  String productId;

  searchProduct(this.productId);

  @override
  _search_proudect createState() => _search_proudect();
}

class _search_proudect extends State<searchProduct> {
  var favouriteService = new FavouriteServices();


  List<Product_Offer> productsForOffer = <Product_Offer>[];
  String nodeOfferName = "offers";
  List<Favourite> favouriteList = <Favourite>[];
  double newPrice;
  bool hasOffer;


  FirebaseDatabase _database = FirebaseDatabase.instance;
  Product searchProduct;


  getPro() async {
    await _database.reference().child("products").child(widget.productId)
      .once()
      .then((DataSnapshot snapshot){
    searchProduct = Product.fromSnapshot(snapshot);

  }).then((v) {
    if (mounted) setState ( () {} );
  });}




@override
 void initState() {
    super.initState();

    getPro();
//
//    _database.reference().child("products").child(widget.productId)
//        .once()
//        .then((DataSnapshot snapshot){
//      searchProduct = Product.fromSnapshot(snapshot);
//
//    }).then((v) {
//      if (mounted) setState ( () {} );
//    });
//
//


  }



  @override
  Widget build(BuildContext context) {
    Color favouriteColor = Colors.grey;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFF21d493),
        title: translations.currentLanguage=='en'?Text("the Search Result"):
        Text("نتيـجـة الـبـحـث"),
        centerTitle: true,
      ),
      body:  Center(
        child: Container(
          height: 40 * SizeConfig.heightMultiplier,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: SizeConfig.getResponsiveHeight(10.0),
                                        left: SizeConfig.getResponsiveWidth(10.0),
                                        right: SizeConfig.getResponsiveWidth(80)),
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                        new BorderRadius.all(Radius.circular(5.0))),
                                    width: SizeConfig.getResponsiveWidth(100.0),
                                    height: SizeConfig.getResponsiveHeight(30.0),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Text(searchProduct.englishQuantityType==null?Container():
                                            translations.currentLanguage=='en'?
                                          "${searchProduct.englishQuantityType}":"${searchProduct.arabicQuantityType}",
                                          style: new TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                              SizeConfig.getResponsiveWidth(25.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.all(15.0),
                                      child: new InkWell(
                                          onTap: () async {
                                            int x = await favouriteService.triggerFavourite(
                                                searchProduct.productId,
                                                searchProduct.categoryId);
                                            if (mounted) setState(() {});
                                          },
                                          child: FutureBuilder<int>(
                                            future: favouriteService.getFavouriteStatus(
                                                searchProduct.productId,
                                                searchProduct.categoryId),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<int> snapshot) {
                                              int x = snapshot.data;
                                              favouriteColor =
                                              (x == 1) ? Colors.red : Colors.grey;
                                              return new Icon(
                                                Icons.favorite,
                                                color: favouriteColor,
                                                size: SizeConfig.getResponsiveHeight(45.0),
                                              );
                                            },
                                          )))
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(new MaterialPageRoute(
                                        builder: (context) =>
                                        new productDetails(currentProduct:searchProduct ,
                                          hasOffer: hasOffer , newPrice: newPrice,)));
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Container(
                                      height: SizeConfig.getResponsiveHeight(200.0),
                                      width: SizeConfig.getResponsiveWidth(260.0),
                                      child:
                                      CachedNetworkImage(
                                        placeholder: (context, url) => const AspectRatio(
                                          aspectRatio: 1.6,
                                        ),
                                        imageUrl:searchProduct.photo,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  )),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: SizeConfig.getResponsiveWidth(150.0)),
                                    child: Text(
                                      translations.currentLanguage=='en'?
                                      "${searchProduct.title}":
                                      "${searchProduct.arabicTitle}",
                                      maxLines: 3,
                                      //   overflow:TextOverflow. ,
                                      style: TextStyle(
                                          fontSize: SizeConfig.getResponsiveWidth(20.0),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  (hasOffer == true)?Container(
                                    margin: EdgeInsets.only(left:SizeConfig.getResponsiveWidth(10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new RichText(
                                          text: new TextSpan(
                                            children: <TextSpan>[
                                              new TextSpan(
                                                text: "${searchProduct.price} " + "LE" ,
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
                                              right: SizeConfig.getResponsiveWidth(10.0),
                                              left: SizeConfig.getResponsiveWidth(100.0),
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
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: SizeConfig.getResponsiveWidth(12.0)),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "LE ${searchProduct.price.toString()}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: SizeConfig.getResponsiveWidth(15),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: SizeConfig.getResponsiveWidth(140.0),
                                            bottom: SizeConfig.getResponsiveHeight(10.0)),
                                        child: Icon(
                                          Icons.shopping_basket,
                                          color: Colors.green,
                                          size: SizeConfig.getResponsiveHeight(20),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))),
        ),
      ),


    );
  }

}

