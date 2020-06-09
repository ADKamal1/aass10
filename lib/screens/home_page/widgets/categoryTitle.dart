import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/Product_Offer.dart';
import 'package:basket/_model/product.dart';
import 'package:basket/utils/size_config.dart';
import '../categoryProducts.dart';

class CategoryTitle extends StatelessWidget {
  String categoryName;
  List<Product> categoryItems = <Product>[];
  List<Product_Offer> productsForOffer = <Product_Offer>[];
  CategoryTitle({this.categoryName , this.categoryItems ,this.productsForOffer});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(SizeConfig.getResponsiveHeight(2.0)),
          margin: EdgeInsets.only(right:SizeConfig.getResponsiveHeight(10.0),left:SizeConfig.getResponsiveHeight(10.0)),
          color: Colors.green,
          child: Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.getResponsiveHeight(5),
                  right: SizeConfig.getResponsiveWidth(4.0),
                  left: SizeConfig.getResponsiveWidth(4.0),
                  bottom: SizeConfig.getResponsiveHeight(5.0)),
              child: Center(
                child: Text(
                  categoryName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.getResponsiveHeight(12)),
                ),
              )),
        ),

        FlatButton(
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => CategoryProducts(
                      categoryName: categoryName,
                      productsForOffer:productsForOffer
                  )));
            },
            child: Container(
              padding: EdgeInsets.all(SizeConfig.getResponsiveHeight(2.0)),
              //margin: EdgeInsets.only(right:SizeConfig.getResponsiveHeight(10.0),left:SizeConfig.getResponsiveHeight(10.0)),
              color: Colors.green,
              child: Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(5),
                      right: SizeConfig.getResponsiveWidth(4.0),
                      left: SizeConfig.getResponsiveWidth(4.0),
                      bottom: SizeConfig.getResponsiveHeight(5.0)),
                  child: Text(
                    translations.text("StorePage.CategorySeeAllText"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.getResponsiveHeight(12)),
                  )),
            ))
      ],
    );
  }
}
