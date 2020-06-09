import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/constants/images.dart';
import 'package:basket/utils/size_config.dart';

class registrationTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            right: 3.64 * SizeConfig.widthMultiplier,
            left: 3.64 * SizeConfig.widthMultiplier),
        height: 5.47 * SizeConfig.heightMultiplier,
        width: 55.96 * SizeConfig.widthMultiplier,
        decoration: BoxDecoration(
            color: Color(0xffd7f7ea),
            borderRadius: new BorderRadius.all(Radius.circular(5.0))),
        child: new TextField(
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 3.64 * SizeConfig.widthMultiplier),
          decoration: new InputDecoration(
            alignLabelWithHint: true,
            border: InputBorder.none,
            fillColor: Color(0xffd7f7ea),
            hintText: translations.text("PhoneNumberConfirmationPage.cardWidget.phoneNumber"),
            hintStyle: TextStyle(fontSize: 3.4 * SizeConfig.widthMultiplier),
            prefixIcon: Image.asset(Images.phoneIcon),
          ),
        ));
  }
}
