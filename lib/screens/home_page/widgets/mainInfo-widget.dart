import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/utils/size_config.dart';

class MainInfo extends StatelessWidget {
  String name, price, quantity, details;

  MainInfo({this.name, this.price, this.quantity, this.details});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(

        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            new Container(
                margin: EdgeInsets.all(0.0),
                alignment: Alignment.centerRight,
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Text(
                      translations
                          .text("ProductProfiletPage.MainInfoPage.ProductName"),
                      style: new TextStyle(
                          fontSize: SizeConfig.getResponsiveWidth(16.0),
                          color: Color.fromRGBO(33, 212, 147, 1),
                          fontWeight: FontWeight.bold
//                                  color: Colors.grey
                          ),
//                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.black, fontSize: SizeConfig.getResponsiveWidth(16.0),),
                    ),
                  )
                ])),
            new Container(
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      translations.text("ProductProfiletPage.MainInfoPage.ProductPrice"),
                      style: new TextStyle(
                          fontSize: SizeConfig.getResponsiveWidth(16.0),
                          color: Color.fromRGBO(33, 212, 147, 1),
                          fontWeight: FontWeight.bold
//                                      fontWeight: FontWeight.bold    color: Colors.grey
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(price,
                          style: TextStyle(color: Colors.black, fontSize: SizeConfig.getResponsiveWidth(16.0),)))
                ])),
            new Container(
                margin: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Column(children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                    translations.text("ProductProfiletPage.MainInfoPage.ProductQuantity"),
                      style: new TextStyle(
                          fontSize: SizeConfig.getResponsiveWidth(16.0),
                          color: Color.fromRGBO(33, 212, 147, 1),
                          fontWeight: FontWeight.bold
//                                         color: Colors.grey
                          ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(quantity,
                          style: TextStyle(color: Colors.black, fontSize: SizeConfig.getResponsiveWidth(16.0),)))
                ])),
            (details == null)
                ? Container()
                : new Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          translations.text("ProductProfiletPage.MainInfoPage.ProductDescription"),
                          style: new TextStyle(
                            fontSize: SizeConfig.getResponsiveWidth(16.0),
                            fontWeight: FontWeight.bold,
//                                         color: Colors.grey
                            color: Color.fromRGBO(33, 212, 147, 1),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: SizeConfig.getResponsiveWidth(20.0), right: SizeConfig.getResponsiveWidth(20.0)),
                        alignment: Alignment.center,
                        child: Text(details,
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      )
                    ])),
          ],
        ),
        preferredSize: Size.fromHeight(300.0));
  }
}
