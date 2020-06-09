import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/cities.dart';
import 'package:basket/_model/regions.dart';
import 'package:basket/utils/size_config.dart';

import 'customListTile.dart';

class ReciptCard extends StatelessWidget {
  cities customerCities;
  double totalPrice = 0.0;

  ReciptCard({this.customerCities , this.totalPrice});
  @override
  Widget build(BuildContext context) {
    //double deliveryCharge = double.parse(customerRegion.fees.toStringAsFixed(2));
    double freeForCashOfDelivery = (totalPrice > 100)?0.0:10;
    double taxes =  double.parse((totalPrice*0.05).toStringAsFixed(2));
    double overAll = double.parse((totalPrice + taxes  + freeForCashOfDelivery).toStringAsFixed(2));

    return Container(
      margin: EdgeInsets.only(
          left: SizeConfig.getResponsiveWidth(5.0),
          right: SizeConfig.getResponsiveWidth(5.0)),
      child: Card(
        elevation: 3.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: SizeConfig.getResponsiveWidth(30.0),
                      height: SizeConfig.getResponsiveHeight(30.0),
                      child: Card(
                          color: Color.fromRGBO(229, 249, 238, 1),
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0)),
                          elevation: 0,
                          child: Image.asset(
                              'assets/images/icons/order-summary.png'))),
                  new Text(
                    translations.text("ConfirmReciptPage.OrderSummaryText"),
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[

                CustomListTile(
                  title: translations.text("ConfirmReciptPage.SubTotalText"),
                  value: "${double.parse(totalPrice.toString()).toStringAsFixed(2)}",
                ),
//                CustomListTile(
//                  title: translations.text("ConfirmReciptPage.DeliveryChargeText"),
//                  value: "${double.parse(deliveryCharge.toString()).toStringAsFixed(2)}",
//                ),
                CustomListTile(
                  title: translations.text("ConfirmReciptPage.DeliveryFreeText"),
                  value: "${double.parse(freeForCashOfDelivery.toString()).toStringAsFixed(2)}",
                ),
                CustomListTile(
                  title: translations.text("ConfirmReciptPage.ValueAddedTaxText"),
                  value: "${double.parse(taxes.toString()).toStringAsFixed(2)}",
                ),
                CustomListTile(
                  title: translations.text("ConfirmReciptPage.TotalText"),
                  value: "${double.parse(overAll.toString()).toStringAsFixed(2)}",
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
