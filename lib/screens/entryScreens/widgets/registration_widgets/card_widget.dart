import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/constants/images.dart';
import 'package:basket/utils/size_config.dart';

import 'textField_widget.dart';

class registrationCardWidget extends StatefulWidget {
  @override
  _registrationCardWidgetState createState() => _registrationCardWidgetState();
}

class _registrationCardWidgetState extends State<registrationCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            left: 9.73 * SizeConfig.widthMultiplier,
            right: 9.73 * SizeConfig.widthMultiplier,
            top: 20.5 * SizeConfig.heightMultiplier,
            bottom: 6.83 * SizeConfig.heightMultiplier),
        alignment: Alignment.center,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 10.0,
          child: Container(
            height: 72.4 * SizeConfig.heightMultiplier,
            width: 85.15 * SizeConfig.widthMultiplier,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: new Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: Text(
                      translations.text("PhoneNumberConfirmationPage.cardWidget.phoneNumber"),
                      style: TextStyle(
                          fontSize: 5.83 * SizeConfig.widthMultiplier,
                          color: Colors.black87,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 72.99 * SizeConfig.widthMultiplier,
                    height: 41 * SizeConfig.heightMultiplier,
                    child: Image.asset(Images.Sign_up),
                  ),
                ),
                registrationTextField(),
                Container(
                  margin: EdgeInsets.only(
                      top: 1.8 * SizeConfig.heightMultiplier,
                      bottom: 1.5 * SizeConfig.heightMultiplier),
                  child: Text(
                      translations.text("PhoneNumberConfirmationPage.cardWidget.registrationMessage"),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 2.0 * SizeConfig.textMultiplier),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
