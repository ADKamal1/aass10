import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/screens/home_page/widgets/product_details.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';

class product_card extends StatefulWidget {
  Product product;
  bool hasOffer = true;
  double newPrice = 0.0;
  product_card({this.product , this.hasOffer , this.newPrice});

  @override
  _productCardState createState() => _productCardState();
}

class _productCardState extends State<product_card> {
  var favouriteService = new FavouriteServices();
  var db = new DatabaseHelper();



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
                            top: SizeConfig.getResponsiveHeight(10.0),
                            left: SizeConfig.getResponsiveWidth(10.0),
                            right: (translations.currentLanguage == 'ar')?
                            SizeConfig.getResponsiveWidth(10):SizeConfig.getResponsiveWidth(80)),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(5.0))),
                        width: SizeConfig.getResponsiveWidth(100.0),
                        height: SizeConfig.getResponsiveHeight(30.0),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text(translations.currentLanguage=='en'?
                              "${widget.product.englishQuantityType}":"${widget.product.arabicQuantityType}",
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
                          margin: EdgeInsets.only(right:(translations.currentLanguage == 'ar')
                              ?SizeConfig.getResponsiveWidth(100):
                          SizeConfig.getResponsiveWidth(15.0) , left :15.0 , top: 15),
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
                        Navigator.push(context,SlideRightRoute(page: productDetails(
                        currentProduct:widget.product , hasOffer: widget.hasOffer ,
                            newPrice: widget.newPrice,)));

                      },

                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Container(
                          padding: EdgeInsets.only(right: 4,left: 4),
                          height: SizeConfig.getResponsiveHeight(160.0),
                          width: SizeConfig.getResponsiveWidth(250.0),
                            child: Container(
                              height: SizeConfig.getResponsiveHeight(50.0),
                              width: SizeConfig.getResponsiveWidth(70.0),
                              child:SizedBox(
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const AspectRatio(
                                    aspectRatio: 1.6,
                                  ),
                                  imageUrl:widget.product.photo,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
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
                          translations.currentLanguage=='en'?
                          "${widget.product.title}":
                          "${widget.product.arabicTitle}",
                          maxLines: 3,
                          //   overflow:TextOverflow. ,
                          style: TextStyle(
                              fontSize: SizeConfig.getResponsiveWidth(20.0),
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      (widget.hasOffer == true)?Container(
                        margin: EdgeInsets.only(left:SizeConfig.getResponsiveWidth(10) , right:SizeConfig.getResponsiveWidth(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new RichText(
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
                            Container(
                              margin: EdgeInsets.only(
                                right:SizeConfig.getResponsiveWidth(12.0),
                                  left: SizeConfig.getResponsiveWidth(12.0)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "LE ${double.parse(widget.newPrice.toString()).toStringAsFixed(2)}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.getResponsiveWidth(15),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: (translations.currentLanguage == 'en')? SizeConfig.getResponsiveWidth(10):SizeConfig.getResponsiveWidth(100.0),
                                  left: (translations.currentLanguage == 'ar')? SizeConfig.getResponsiveWidth(10):SizeConfig.getResponsiveWidth(140.0),
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
                      Container(
                        margin: EdgeInsets.only(left:SizeConfig.getResponsiveWidth(20),right:SizeConfig.getResponsiveWidth(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: SizeConfig.getResponsiveWidth(12.0)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "LE ${widget.product.price.toString()}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.getResponsiveWidth(15),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: (translations.currentLanguage == 'en')? SizeConfig.getResponsiveWidth(10):SizeConfig.getResponsiveWidth(140.0),
                                  left: (translations.currentLanguage == 'ar')? SizeConfig.getResponsiveWidth(10):SizeConfig.getResponsiveWidth(140.0),
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