import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';

import 'appbar_icon.dart';

AppBar myCartAppbar(GlobalKey<ScaffoldState> _scaffoldKey, Widget titleWidget) {
  return AppBar(
    centerTitle: true,
    title: titleWidget,
    elevation: 0.0,
    leading: Container(
        child: InkWell(
      onTap: () => _scaffoldKey.currentState.openDrawer(),
      child: translations.currentLanguage=='en'?Icon(Icons.format_align_left, color: Colors.white, ):
          Icon(Icons.format_align_right ,color: Colors.white,),
    )),
    iconTheme: IconThemeData(color: Colors.black),
    //add this line her
    backgroundColor: Color(0XFF21d493),
    actions: <Widget>[

    ],
  );
}
