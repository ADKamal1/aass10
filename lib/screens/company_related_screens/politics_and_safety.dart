import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/familyBasket.dart';
import 'package:basket/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class politicsAndSafety extends StatefulWidget {
  _pliticsAndSafety createState() => new _pliticsAndSafety();
}

class _pliticsAndSafety extends State<politicsAndSafety> {

  familyBasket familyDetails;
  FirebaseDatabase _database = FirebaseDatabase.instance;
  void getAboutCompany() async {
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
  initState(){
    getAboutCompany();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              child: Text(translations.text("PrivacyPolicyPage.title"),
                  style: TextStyle(fontSize: 17.0, color: Colors.white))
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
            (familyDetails.Policy == null)?
            Container():
                translations.currentLanguage=='en'?
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 45, left: 15, right: 10, bottom: 20),
                child: Text(
                  familyDetails.Policy,
                  style: TextStyle(
                      wordSpacing: 6,
                      fontSize: 20,
                      fontFamily: 'SourceSansPro',
                      color: Colors.black),
                ),
              ),
            ):
                (familyDetails.arabicPolicy == null)?
                Container():
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 45, left: 15, right: 10, bottom: 20),
                    child: Text(
                      familyDetails.arabicPolicy,
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
