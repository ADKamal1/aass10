import 'package:flutter/material.dart';
import 'package:basket/Localization/settings.dart';
import 'package:basket/Localization/translation/global_translation.dart';
import 'package:basket/_model/customers.dart';
import 'package:basket/screens/company_related_screens/about_company.dart';
import 'package:basket/screens/company_related_screens/contact_us.dart';
import 'package:basket/screens/company_related_screens/politics_and_safety.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/entryScreens/welcome.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../MyOrder.dart';

//import '../myordersScreen.dart';

class ProfileBody extends StatefulWidget {
  final BaseAuth auth;

  ProfileBody({this.auth});

  @override
  _ProfileBody createState() => _ProfileBody();
}


class _ProfileBody extends State<ProfileBody> {

  bool isAuthenticated = false;
  customers authenticatedCustomer;

  @override
  void initState() {
    super.initState();

      FirebaseAuth.instance.currentUser().then((user) async{
        if(user != null){
          String userId = user.uid;
          isAuthenticated = true;
          await FirebaseDatabase.instance.reference().child("customers").
          child(userId).once().then((DataSnapshot snapshot){
            authenticatedCustomer = customers.fromSnapshot(snapshot);
          });
          print("\n\n\n"+userId);
          // usser is authenticated..
        }else{
          isAuthenticated = false;
        }
      }).then((d){
        if(mounted)
          setState(() {

          });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15,top:30)
            : EdgeInsets.only(bottom: 0,top:15),
        child: ListTile(
            dense: true,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => politicsAndSafety())),
            leading: Image.asset(
              'assets/images/side_menu_image/policy.png',
              color: Color(0XFF21d493),
            ),
            title: Text(
              translations.text("SideMenuPage.sidePolitics"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSansPro',
                  fontSize: SizeConfig.getResponsiveHeight(13),
                  color: Colors.black),
            )),
      ),
      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15)
            : EdgeInsets.only(bottom: 0),
        child: ListTile(
            dense: true,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => contactUs())),
            leading: Image.asset(
              'assets/images/side_menu_image/contact.png',
              color: Color(0XFF21d493),
            ),
            title: Text(
              translations.text("SideMenuPage.sideContact"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSansPro',
                  fontSize: SizeConfig.getResponsiveHeight(13),
                  color: Colors.black),
            )),
      ),
      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15)
            : EdgeInsets.only(bottom: 0),
        child: ListTile(
            dense: true,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => aboutCompany())),
            leading: Image.asset(
              'assets/images/side_menu_image/about.png',
              color: Color(0XFF21d493),
            ),
            title: Text(
              translations.text("SideMenuPage.sideAboutCompany"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSansPro',
                  fontSize: SizeConfig.getResponsiveHeight(13),
                  color: Colors.black),
            )),
      ),

      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15)
            : EdgeInsets.only(bottom: 0),
        child: ListTile(
            dense: true,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage())),
            leading: Image.asset(
              'assets/images/side_menu_image/language.png',
              color: Color(0XFF21d493),
            ),
            title: Text(
              translations.text("SideMenuPage.changeLanguage"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSansPro',
                  fontSize: SizeConfig.getResponsiveHeight(13),
                  color: Colors.black),
            )),
      ),
      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15)
            : EdgeInsets.only(bottom: 0),
        child: ListTile(
            dense: true,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyOrder(
//                  authenticatedCustomer: widget.authenticatedCustomer,
//                  isAuthenticated: widget.isAuthenticated,
                ))),
            leading: Padding(
              padding: translations.currentLanguage=='en'?const EdgeInsets.only(left: 8.0):const EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.shopping_cart,
                color: Color(0XFF21d493),
              ),
            ),
            title: Text(translations.text("SideMenuPage.Myorder"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceSansPro',
                  fontSize: SizeConfig.getResponsiveHeight(13),
                  color: Colors.black),
            )),
      ),

      isAuthenticated==true?
      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15)
            : EdgeInsets.only(bottom: 0),
        child: ListTile(
            dense: true,
            onTap: () async {
                  await widget.auth.signOut();
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new Welcome(
                            auth: widget.auth,
                          )));
                },
                leading: Image.asset('assets/images/side_menu_image/login.png'),
                title: Text(
                  translations.text("SideMenuPage.LogOut"),
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: SizeConfig.getResponsiveHeight(13),
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                )),
      ):
      Container(
        margin: MediaQuery.of(context).size.height >= 720
            ? EdgeInsets.only(bottom: 15)
            : EdgeInsets.only(bottom: 0),
        child: ListTile(
            onTap: () async {
              await widget.auth.signOut();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new Welcome(
                    auth: widget.auth,
                  )));
            },
            leading: Image.asset('assets/images/side_menu_image/login.png'),
            title: Text(
              translations.text("SideMenuPage.LogIn"),
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: SizeConfig.getResponsiveHeight(13),
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            )),
      )


    ]);
  }
}
