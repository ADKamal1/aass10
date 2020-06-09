import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/familyBasket.dart';
import 'package:basket/utils/size_config.dart';


class aboutCompany extends StatefulWidget {
  _aboutCompany createState() => new _aboutCompany();
}

class _aboutCompany extends State<aboutCompany> {

  familyBasket familyDetails;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  void getAboutCompany() async
  {
    await _database.reference()
        .child("familyBasket")
        .once()
        .then((DataSnapshot snapshot){
      Map<dynamic, dynamic> familBasket = snapshot.value;
      familBasket.forEach((key, value) {
        familyDetails = familyBasket.fromMap(value, key);
      });
    });
    if(mounted){
      setState(() {

      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getAboutCompany();
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0XFF21d493),
          leading: Container(
            margin: EdgeInsets.only(top: 10.0),
            child:InkWell(
              onTap: (){Navigator.pop(context);},
              child:Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),),
          ),
          title: Container(
              margin: EdgeInsets.only(top: 10.0),
              child: translations.currentLanguage=='en'?
              Text("About Company",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 17.0, color: Colors.white)):
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text("مـعلـومــات عـن الشــركـــــة",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 17.0, color: Colors.white)),
              )
          ),
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body:(familyDetails == null)? Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ): ListView(
          children: <Widget>[
            Container(
                color: Color(0XFF21d493),
                height: SizeConfig.getResponsiveHeight(120),
                child: Image.asset('assets/images/politices.png')),
            (familyDetails.about == null)?
            Container():
            translations.currentLanguage=='en'?
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 45, left: 15, right: 10, bottom: 20),
                child: Text(
                  familyDetails.about,
                  style: TextStyle(
                      wordSpacing: 6,
                      fontSize: 20,
                      fontFamily: 'SourceSansPro',
                      color: Colors.black),
                ),
              ),
            ):(familyDetails.aboutArabic == null)?
            Container():
            Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 45, left: 15, right: 10, bottom: 20),
                child: Text(
                  familyDetails.aboutArabic,
                  style: TextStyle(
                      wordSpacing: 6,
                      fontSize: 20,
                      fontFamily: 'SourceSansPro',
                      color: Colors.black),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
