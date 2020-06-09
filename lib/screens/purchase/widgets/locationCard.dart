import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/utils/size_config.dart';

class LocationCard extends StatelessWidget {
  String address, telNo = (translations.currentLanguage == 'ar')?"لا يوجد رقم تليفون":"no number provided";
  LocationCard({this.address, this.telNo});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
        child: Container(
          color: Color.fromRGBO(229, 249, 238, 1),
          padding: EdgeInsets.all(SizeConfig.getResponsiveHeight(10)),
          margin: EdgeInsets.all(SizeConfig.getResponsiveHeight(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Color.fromRGBO(229, 249, 238, 1),
                margin: EdgeInsets.only(bottom: 5.0),
                child: Text(
                  translations.text("PuchaseLocationPage.HomeText"),
                  style: TextStyle(
                      fontSize: SizeConfig.getResponsiveHeight(15.0),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5.0),
                child: Text((address== null)?((translations.currentLanguage == 'ar')?"لا يوجد عنوان":"there's no address"):address,
                    style: TextStyle(
                        fontSize: SizeConfig.getResponsiveHeight(12.0))),
              ),
              Container(
                child: Text(
                  (telNo== null)?((translations.currentLanguage == 'ar')?"لا يوجد رقم تليفون":"there's no phone number"):telNo,

                  style:
                      TextStyle(fontSize: SizeConfig.getResponsiveHeight(12.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
