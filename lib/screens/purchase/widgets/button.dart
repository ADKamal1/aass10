import 'package:flutter/material.dart';
import 'package:basket/screens/purchase/puchaseLocation.dart';
import 'package:basket/utils/size_config.dart';

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: SizeConfig.getResponsiveHeight(100.0),
          right: SizeConfig.getResponsiveWidth(120.0),
          left: SizeConfig.getResponsiveWidth(120.0),
          top: SizeConfig.getResponsiveHeight(10)),
      child: new FlatButton(
        padding: EdgeInsets.all(7.0),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0)),
        color: Color(0XFF21d493),
        child: new Text(
          "Purchase",
          style: TextStyle(
              fontSize: SizeConfig.getResponsiveHeight(15),
              color: Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new PurchaseLocation()));
        },
      ),
    );
  }
}
