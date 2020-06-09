import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';

class productBasketCard extends StatefulWidget {
  Product product;
  bool hasOffer = false;
  double newPrice = 0.0;

  final Function() notifyParent;
  productBasketCard({this.product, Key key, @required this.notifyParent , this.hasOffer , this.newPrice})
      : super(key: key);

  @override
  _productCardState createState() => _productCardState();
}

class _productCardState extends State<productBasketCard> {
  var db = new DatabaseHelper();
  int quantity = 0;
  @override
  void initState() {
    db.isProductFoundInBasketTable(widget.product.productId).then((val) {
      if (true) {
        db.getProductQuantityFromBasket(widget.product.productId).then((val) {
          widget.product.quantity = val;
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
    return (widget.product.quantity  == 0)
        ? Container(
           child:Text("df"),//////////--------- what do you want from this text !!!!!!
            width: 0,
            height: 0,
          )
        : Container(
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
                          right: (translations.currentLanguage=='ar')?SizeConfig.getResponsiveWidth(0):SizeConfig.getResponsiveWidth(100.0),
                          left: (translations.currentLanguage == 'ar')?SizeConfig.getResponsiveWidth(70):SizeConfig.getResponsiveWidth(0),
                          top: SizeConfig.getResponsiveHeight(20.0),
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
                          child: Text(translations.currentLanguage=='en'?
                            "${widget.product.englishQuantityType}":"${widget.product.arabicQuantityType}",
                            style: new TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.getResponsiveWidth(20.0)),
                          ),
                        ),
                      ),
                    ),

                    (translations.currentLanguage=='ar')? Container(
                      width:60
                    ):Container(width: 0.0,height: 0.0,),


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
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: SizeConfig.getResponsiveWidth(12.0),
                              bottom: SizeConfig.getResponsiveHeight(5.0)),
                          child: Text(
                            translations.currentLanguage=='en'?
                            "${widget.product.title}":
                            "${widget.product.arabicTitle}",
                            maxLines: 3,
                            //   overflow:TextOverflow. ,
                            style: TextStyle(
                              fontSize: SizeConfig.getResponsiveWidth(20.0),
//                        fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
//                              Navigator.of(context).push(new MaterialPageRoute(
//                                  builder: (context) => new productDetails(
//                                      currentProduct: widget.product,newPrice:widget.newPrice,hasOffer: widget.hasOffer,)));
                            },
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Container(
                                height: SizeConfig.getResponsiveHeight(160.0),
                                width: SizeConfig.getResponsiveWidth(260.0),
                                child:SizedBox(
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
                            )),
                        (widget.hasOffer == true)?Container(
                          margin: EdgeInsets.only(left:SizeConfig.getResponsiveWidth(20) ,bottom: SizeConfig.getResponsiveHeight(30)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new RichText(
                                text: new TextSpan(

                                  children: <TextSpan>[
                                    new TextSpan(

                                      text: "${widget.product.price} " + "SAR" ,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.red,
                                          fontSize: SizeConfig.getResponsiveWidth(20),
                                          decorationThickness: 3
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: SizeConfig.getResponsiveWidth(20.0) ,
                                    bottom: SizeConfig.getResponsiveHeight(1)),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "LE ${double.parse(widget.newPrice.toString()).toStringAsFixed(2)}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.getResponsiveWidth(20),
                                  ),
                                ),
                              ),
//                              Container(
//                                margin: EdgeInsets.only(
//                                    right: SizeConfig.getResponsiveWidth(10.0),
//                                    left: SizeConfig.getResponsiveWidth(140.0),
//                                    bottom: SizeConfig.getResponsiveHeight(10.0)),
//                                child: Icon(
//                                  Icons.shopping_basket,
//                                  color: Colors.green,
//                                  size: SizeConfig.getResponsiveHeight(35),
//                                ),
//                              )
                            ],
                          ),
                        ):
                        Container(
                          margin: EdgeInsets.only(
                              bottom: SizeConfig.getResponsiveHeight(10.0),
                              right: SizeConfig.getResponsiveWidth(80.0)),
                          child: Text(
                            "LE ${widget.product.price.toString()}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: SizeConfig.getResponsiveWidth(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(

                          left: SizeConfig.getResponsiveWidth(20.0),
                          right: SizeConfig.getResponsiveWidth(20.0),
                          top: SizeConfig.getResponsiveHeight(20.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              await db.incrementProductInBasket(
                                  widget.product.productId,
                                  widget.product.categoryId);
                              widget.product.quantity++;
                              if (mounted) {
                                setState(() {});
//                            widget.notifyParent();
                              }
                            },
                            child: Container(
                              height: SizeConfig.getResponsiveHeight(35.0),
                              width: SizeConfig.getResponsiveWidth(30.0),
                              child: Center(
                                  child: Text(
                                "+",
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.getResponsiveHeight(25.0)),
                              )),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width:
                                          SizeConfig.getResponsiveHeight(2))),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.getResponsiveHeight(15.0),
                                bottom: SizeConfig.getResponsiveHeight(15.0)),
                            child: Text(
                                widget.product.quantity.toString(),
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.getResponsiveWidth(25.0)),
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                await db.decrementProductInBasket(
                                    widget.product.productId,
                                    widget.product.categoryId);
                                widget.product.quantity--;

                                if (widget.product.quantity == 0) {
                                  widget.notifyParent();
                                } else {
                                  if (mounted) {
                                    setState(() {});
                                  }

//                          widget.notifyParent();
                                }
                              },
                              child: Container(
                                height: SizeConfig.getResponsiveHeight(35.0),
                                width: SizeConfig.getResponsiveWidth(30.0),
                                child: Center(
                                    child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.getResponsiveHeight(25.0)),
                                )),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width:
                                            SizeConfig.getResponsiveWidth(2))),
                              ))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ));
  }
}
