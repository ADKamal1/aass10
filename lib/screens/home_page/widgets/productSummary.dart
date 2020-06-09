import 'package:basket/Localization/translation/global_translation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/database/database_helper.dart';
import 'package:basket/services/favouriteServices.dart';
import 'package:basket/utils/size_config.dart';

class productSummaryCard extends StatefulWidget {
  Product product;

  productSummaryCard({this.product});

  @override
  _productSummaryCardState createState() => _productSummaryCardState();
}

class _productSummaryCardState extends State<productSummaryCard> {
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
        child: Row(
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              color: Colors.white,
              elevation: 3,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(SizeConfig.getResponsiveWidth(10.0)),
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: new BorderRadius.all(Radius.circular(5.0))),
                          width: SizeConfig.getResponsiveWidth(50.0),
                          height: SizeConfig.getResponsiveHeight(20.0),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(translations.currentLanguage=='en'?
                                "${widget.product.englishQuantityType}":"${widget.product.arabicQuantityType}",
                                style: new TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold,
                                    fontSize: SizeConfig.getResponsiveWidth(15.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 50,),
                      Container(
                          margin: EdgeInsets.all(10.0),
                          child: new InkWell(
                              onTap: () async {
                                int x = await favouriteService.triggerFavourite(
                                    widget.product.productId, widget.product.categoryId);
                                if (mounted) setState(() {});
                              },
                              child: FutureBuilder<int>(
                                future: favouriteService.getFavouriteStatus(
                                    widget.product.productId, widget.product.categoryId),
                                builder: (BuildContext context,
                                    AsyncSnapshot<int> snapshot) {
                                  int x = snapshot.data;
                                  favouriteColor = (x == 1) ? Colors.red : Colors.grey;
                                  return new Icon(
                                    Icons.favorite,
                                    color: favouriteColor,
                                    size: SizeConfig.getResponsiveHeight(30.0),
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
                            height: SizeConfig.getResponsiveHeight(90.0),
                            width: SizeConfig.getResponsiveWidth(200.0),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Container(
                                height: SizeConfig.getResponsiveHeight(160.0),
                                width: SizeConfig.getResponsiveWidth(260.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const AspectRatio(
                                      aspectRatio: 1.6,
                                    ),
                                    imageUrl:widget.product.photo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ),

                        ],
                      ),

                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}


