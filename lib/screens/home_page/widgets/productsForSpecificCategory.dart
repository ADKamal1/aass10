import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/screens/home_page/widgets/product_details.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';

class productsForSpecificCategory extends StatefulWidget {
  Product product;
  bool hasOffer = false;
  double newPrice = 0.0;
  final Function() notifyParent;

  productsForSpecificCategory(
      {this.product,
      Key key,
      @required this.notifyParent,
      this.hasOffer,
      this.newPrice})
      : super(key: key);

  @override
  _productCardState createState() => _productCardState();
}

class _productCardState extends State<productsForSpecificCategory> {
  var favouriteService = new FavouriteServices();

  @override
  Widget build(BuildContext context) {
    Color favouriteColor = Colors.grey;
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: Colors.white,
          elevation: 3,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        right: SizeConfig.getResponsiveWidth(20.0),
                        left: SizeConfig.getResponsiveWidth(20.0),
                        top: SizeConfig.getResponsiveHeight(10.0),
                        bottom: SizeConfig.getResponsiveHeight(10.0)),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius:
                            new BorderRadius.all(Radius.circular(5.0))),
                    width: SizeConfig.getResponsiveWidth(90.0),
                    height: SizeConfig.getResponsiveHeight(25.0),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          translations.currentLanguage=='en'?
                          "${widget.product.englishQuantityType}":"${widget.product.arabicQuantityType}",
                          style: new TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.getResponsiveWidth(20.0)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.all(15.0),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => new productDetails(
                                      currentProduct: widget.product,
                                      hasOffer: widget.hasOffer,
                                      newPrice: widget.newPrice,
                                    )));
                          },
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              padding: EdgeInsets.only(right: 4, left: 4),
                              height: SizeConfig.getResponsiveHeight(160.0),
                              width: SizeConfig.getResponsiveWidth(250.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      const AspectRatio(
                                    aspectRatio: 1.6,
                                  ),
                                  imageUrl: widget.product.photo,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                right: SizeConfig.getResponsiveWidth(150.0),
                                top: SizeConfig.getResponsiveWidth(30.0)),
                            child: Text(
                              translations.currentLanguage == 'en'
                                  ? "${widget.product.title}"
                                  : "${widget.product.arabicTitle}",
                              maxLines: 3,
                              //   overflow:TextOverflow. ,
                              style: TextStyle(
                                  fontSize: SizeConfig.getResponsiveWidth(20.0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          (widget.hasOffer == true)
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: SizeConfig.getResponsiveWidth(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new RichText(
                                        text: new TextSpan(
                                          children: <TextSpan>[
                                            new TextSpan(
                                              text: "${widget.product.price} " +
                                                  "LE",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationColor: Colors.red,
                                                  fontSize: SizeConfig
                                                      .getResponsiveWidth(15),
                                                  decorationThickness: 3),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: SizeConfig.getResponsiveWidth(
                                                12.0)),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "LE ${double.parse(widget.newPrice.toString()).toStringAsFixed(2)}",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.getResponsiveWidth(
                                                    15),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            right:
                                                SizeConfig.getResponsiveWidth(
                                                    10.0),
                                            left: SizeConfig.getResponsiveWidth(
                                                100.0),
                                            bottom:
                                                SizeConfig.getResponsiveHeight(
                                                    10.0)),
                                        child: Icon(
                                          Icons.shopping_basket,
                                          color: Colors.green,
                                          size: SizeConfig.getResponsiveHeight(
                                              35),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.getResponsiveWidth(
                                              12.0)),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "LE ${widget.product.price.toString()}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.getResponsiveWidth(15),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: SizeConfig.getResponsiveWidth(
                                              140.0),
                                          bottom:
                                              SizeConfig.getResponsiveHeight(
                                                  10.0)),
                                      child: Icon(
                                        Icons.shopping_basket,
                                        color: Colors.green,
                                        size:
                                            SizeConfig.getResponsiveHeight(35),
                                      ),
                                    )
                                  ],
                                )
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
