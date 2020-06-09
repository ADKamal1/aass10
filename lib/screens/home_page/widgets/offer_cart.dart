import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/offers.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/screens/home_page/widgets/product_details.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_database/firebase_database.dart';

class OfferCard extends StatefulWidget {
  Product product;
  offers offer;
  double newPrice = 0.0;
  OfferCard({this.product , this.offer , this.newPrice});

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  var favouriteService = new FavouriteServices();


  @override
  void initState() {
    super.initState();
    print("\n\n\n\n\n");
    print(widget.product.photo);
  }
  @override
  Widget build(BuildContext context) {
    Color favouriteColor = Colors.grey;
    return FittedBox(
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
                            right:
                            translations.currentLanguage=='en'?
                            SizeConfig.getResponsiveWidth(170.0):SizeConfig.getResponsiveWidth(0),
                            left: SizeConfig.getResponsiveWidth(0.0),
                            bottom: SizeConfig.getResponsiveHeight(10.0)),
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Container(
                            height: SizeConfig.getResponsiveHeight(40.0),
                            width: SizeConfig.getResponsiveWidth(80.0),
                            child: Image.asset(
                              "assets/images/tag.png",
                              width: SizeConfig.getResponsiveWidth(400.0),
                              height: SizeConfig.getResponsiveHeight(200.0),
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      (translations.currentLanguage=='ar')?Container(width: 0,):Container(),
                      Container(
                          margin: (translations.currentLanguage=='ar')?EdgeInsets.only(right: 200):EdgeInsets.all(20.0),
                          child: new InkWell(
                              onTap: () async {
                                int x = await favouriteService.triggerFavourite(
                                    widget.product.productId,
                                    widget.product.categoryId);
                                if (mounted) setState(() {});
                              },
                              child: FutureBuilder<int>(
                                future: favouriteService.getFavouriteStatus(
                                    widget.product.productId,
                                    widget.product.categoryId),
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
                            new productDetails(currentProduct:widget.product , offer:widget.offer , hasOffer: true,newPrice: widget.newPrice,)));
                      },
                    child:FittedBox(
                      fit: BoxFit.contain,
                      child: Container(
                        height: SizeConfig.getResponsiveHeight(160.0),
                        width: SizeConfig.getResponsiveWidth(250.0),
                        child: Container(
                          height: SizeConfig.getResponsiveHeight(50.0),
                          width: SizeConfig.getResponsiveWidth(70.0),
                          child: SizedBox(
                            width: double.infinity,
                            child:
                            CachedNetworkImage(
                              placeholder: (context, url) => const AspectRatio(
                                aspectRatio: 1.6,
                              ),
                              imageUrl:widget.product.photo,
                              fit: BoxFit.cover,
                            ),
                          )
                        ),

                      ),
                    )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                          left: SizeConfig.getResponsiveWidth(40),
                            right: SizeConfig.getResponsiveWidth(40)),
                        child: Text(
                          translations.currentLanguage=='en'?"${widget.product.title}":
                              "${widget.product.arabicTitle}",
                          maxLines: 3,
                          //   overflow:TextOverflow. ,
                          style: TextStyle(
                              fontSize: SizeConfig.getResponsiveWidth(20.0),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left:SizeConfig.getResponsiveWidth(20),right:SizeConfig.getResponsiveWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.getResponsiveWidth(12.0)),
                              alignment: Alignment.centerLeft,
                              child: new RichText(
                              text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(
                                  text: "${widget.product.price} " + "LE" ,
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
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.getResponsiveWidth(5.0) , right: SizeConfig.getResponsiveWidth(5.0)),
                              //alignment: Alignment.centerLeft,
                              child: Text(
                                " ${double.parse(widget.newPrice.toString()).toStringAsFixed(2)} SAR",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.getResponsiveWidth(15),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                right: (translations.currentLanguage == 'ar')?SizeConfig.getResponsiveWidth(100):SizeConfig.getResponsiveWidth(40.0),
                                  left: (translations.currentLanguage=='ar')?SizeConfig.getResponsiveWidth(0):SizeConfig.getResponsiveWidth(140.0),
                                  bottom: SizeConfig.getResponsiveHeight(10.0)),
                              child: Icon(
                                Icons.shopping_basket,
                                color: Colors.green,
                                size: SizeConfig.getResponsiveHeight(35),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
