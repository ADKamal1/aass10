import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/categories.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/utils/size_config.dart';
import '../categoryProducts.dart';

class mainCard extends StatefulWidget {
  String title;
  String categoryId;
  categories category;
  List<Product> categoryItems = <Product>[];
  List<Product_Offer> productsForOffer = <Product_Offer>[];
  mainCard({this.productsForOffer,this.title , this.categoryItems , this.category});
  @override
  _mainCardState createState() => _mainCardState();
}


class _mainCardState extends State<mainCard> {

  @override
  void initState() {
    super.initState();
    print("\n\n\n\ ");
    print(widget.category.photo);
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: BoxFit.contain,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                    right: 0.0, top: 0.0, left: 1.0, bottom: 0.0),
                width: SizeConfig.getResponsiveHeight(25),
                height: SizeConfig.getResponsiveHeight(25),
                color: Colors.transparent,
                child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: InkWell(
                        onTap: () {
                          print("\n\n\n\n+ id1 : ");
                          print(widget.category.categoryID);
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => CategoryProducts(
                                category: widget.category,
                                    categoryName: widget.title,
                                productsForOffer: widget.productsForOffer,
                                  )));
                        },
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            height: SizeConfig.getResponsiveHeight(150.0),
                            width: SizeConfig.getResponsiveWidth(150.0),
                            child:
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2000.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const AspectRatio(
                                      aspectRatio: 1.6,
                                    ),
                                    imageUrl:widget.category.photo,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                            )

                          ),
                        )))),
            Container(
              margin: EdgeInsets.only(top: 0.0, left: 1.0),
              child: Text(widget.title,
                  style:
                      TextStyle(fontSize: SizeConfig.getResponsiveHeight(4))),
            )
          ],
        ));
  }
}
