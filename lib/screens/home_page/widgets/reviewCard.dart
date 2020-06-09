import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';

class reviewCard extends StatefulWidget {
  Product product;
  bool hasOffer = true;
  double newPrice = 0.0;
   reviewCard({this.product , this.hasOffer , this.newPrice});

  @override
  _reviewCardState createState() => _reviewCardState();
}

class _reviewCardState extends State<reviewCard> {
  var db = new DatabaseHelper();
int quantity = 0;
  @override
  void initState() {
    db.isProductFoundInBasketTable(widget.product.productId).then((val) {
      if (true) {
        db.getProductQuantityFromBasket(widget.product.productId).then((val) {
          quantity = val;
          if (mounted) {
            setState(() {});
          }
        });
      }
    });
  }

  var favouriteService = new FavouriteServices();
  @override
  Widget build(BuildContext context) {
    Color favouriteColor = Colors.grey;
    return Container(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.white,
          elevation: 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig.getResponsiveWidth(10.0),
                        left: SizeConfig.getResponsiveWidth(10.0),
                        top: SizeConfig.getResponsiveHeight(5.0),
                        bottom: SizeConfig.getResponsiveHeight(10.0)),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))),
                    width: SizeConfig.getResponsiveWidth(90.0),
                    height: SizeConfig.getResponsiveHeight(10.0),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text( translations.currentLanguage=='en'?
                          "${widget.product.englishQuantityType}":"${widget.product.arabicQuantityType}",
                          style: new TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.getResponsiveWidth(9.0)),
                        ),
                      ),
                    ),
                  ),
                  (widget.hasOffer == true)?Container(
                    margin: EdgeInsets.only(left:SizeConfig.getResponsiveWidth(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Container(
                          margin: EdgeInsets.only(
                              right: SizeConfig.getResponsiveWidth(10.0)),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "LE ${double.parse(widget.newPrice.toString()).toStringAsFixed(2)}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: SizeConfig.getResponsiveWidth(9),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ):
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.getResponsiveHeight(0.0),
                        right: SizeConfig.getResponsiveWidth(8.0)),
                    child: Text(
                      "${widget.product.price.toString()} LE",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: SizeConfig.getResponsiveWidth(9),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            left: SizeConfig.getResponsiveWidth(10.0),
                            bottom: SizeConfig.getResponsiveHeight(0.0)),
                        child: Text(
                          translations.currentLanguage=='en'?
                          "${widget.product.title}":
                          "${widget.product.arabicTitle}",
                          maxLines: 3,
                          //   overflow:TextOverflow. ,
                          style: TextStyle(
                            fontSize: SizeConfig.getResponsiveWidth(12.0),
//                        fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      InkWell(
                        child: Container(
                          height: SizeConfig.getResponsiveHeight(50.0),
                          width: SizeConfig.getResponsiveWidth(70.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const AspectRatio(
                                aspectRatio: 1.6,
                              ),
                              imageUrl:widget.product.photo,
                              fit: BoxFit.cover,
                            ),
                          )
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.getResponsiveHeight(0.0),
                                right: SizeConfig.getResponsiveWidth(0.0)),
                            child: Text(
                              translations.currentLanguage=='en'?
                              "Quantity :  ${quantity.toString()}":
                              "الكميــة :  ${quantity.toString()}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: SizeConfig.getResponsiveWidth(12),
                              ),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                ],
              )
            ],
          ),
        ));
  }
}
